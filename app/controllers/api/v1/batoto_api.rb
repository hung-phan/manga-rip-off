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
          requires :link, type: String , desc: "Page link"
        end
        post "/" do
          doc = Nokogiri::HTML(open(params[:link]))

          chapters = doc.css('table.chapters_list tr.lang_English').map do |row|
            link = row.css('a')[0]
            {:href => link['href'], :title => link.content}
          end
          chapters
        end

        desc "get chapter page"
        params do
          requires :link, type: String , desc: "Page link"
        end
        post "/view" do
          doc = Nokogiri::HTML(open(params[:link]))
          images = []

          page_links = doc.css('select#page_select option').map do |option|
            # get all page link
            option['value']
          end

          EventMachine.run do
            multi = EventMachine::MultiRequest.new

            page_links.each_with_index.map do |link, index|
              # get page link asynchronously
              multi.add index, EventMachine::HttpRequest.new(link).get
            end

            multi.callback do
              multi.responses[:callback].to_a.sort_by do |callback_data|
                callback_data[0]
              end.each do |callback_data|
                begin
                  images << Nokogiri::HTML(callback_data[1].response).css('img#comic_page')[0]['src']
                rescue
                  # TODO
                  # do nothing
                end
              end
              p images
              logger.info "Error request: #{multi.responses[:errback].length}"
              EventMachine.stop
            end
          end

          images
        end
      end
    end
  end
end

