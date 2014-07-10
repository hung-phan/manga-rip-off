require 'nokogiri'
require 'net/http'
require 'eventmachine'
require 'open-uri'
require 'uri'

module API
  module V1
    class BatotoApi < Grape::API
      include API::V1::Defaults

      helpers do
        def logger
          BatotoApi.logger
        end
      end

      # GET /api/v1/batoto

      resource :batoto do
        # GET /api/v1/batoto
        desc "get manga with the name"
        get "/:name" do
          # name condition
          params[:type] = "c"

          # query
          doc = Nokogiri::HTML(open(URI.escape(
            "http://www.batoto.net/search?name=#{params[:name]}&name_cond=#{params[:type]}"
          )))

          # Search for nodes by css
          links = doc.css('tr strong a').map do |link|
            {:title => link.content, :href => link['href']}
          end
          links
        end

        desc "get manga main page"
        params do
          requires :link, type: String, desc: "Page link"
        end
        post "/" do
          doc = Nokogiri::HTML(open(params[:link]))

          image = doc.css('div.ipsBox')[0].css('img')[0]['src']
          chapters = doc.css('table.chapters_list tr.lang_English').map do |row|
            link = row.css('a')[0]
            {:href => link['href'], :title => link.content}
          end
          { :image => image, :chapters => chapters }
        end

        desc "get chapter page"
        params do
          requires :link, type: String, desc: "Page link"
        end
        post "/view" do
          doc = Nokogiri::HTML(open(params[:link]))
          images = []

          # get link of previous chapter
          prev_link = doc.css(
            'li[style="display: inline-block; float: left; margin-top:-11px;"]'
          )[0].css('a')[0]['href']

          # get link of next chapter
          next_link = doc.css(
            'li[style="display: inline-block; float: right; margin-top:-11px;"]'
          )[0].css('a')[0]['href']

          # get all page link
          chapter_name = doc.css('select[name="chapter_select"] option').detect { |option|
            option['selected']
          }.content
          page_links = doc.css('select#page_select option').map do |option|
            option['value']
          end

          EventMachine.run do
            multi = EventMachine::MultiRequest.new

            page_links.each_with_index.map do |link, index|
              # get page link asynchronously
              multi.add index, EventMachine::HttpRequest.new(link).get
            end

            multi.callback do
              multi.responses[:callback].to_a.sort_by { |callback_data|
                callback_data[0]
              }.each { |callback_data|
                begin
                  images << Nokogiri::HTML(callback_data[1].response).css('img#comic_page')[0]['src']
                rescue
                  # TODO do something to rescue from 404 for requesting page in batoto
                end
              }
              logger.info "Error request: #{multi.responses[:errback].length}"
              EventMachine.stop
            end
          end

          {:prev => prev_link, :next => next_link, :title => chapter_name, :images => images}
        end
      end
    end
  end
end

