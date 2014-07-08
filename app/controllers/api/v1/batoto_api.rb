require 'nokogiri'
require 'thread'
require 'open-uri'

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
          # c for containIn
          params[:type] = "c"
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
          hydra = Typhoeus::Hydra.hydra(max_concurrency: 10)

          doc.css('select#page_select option').map do |option|
            # get all page link
            option['value'].gsub 'http://', ''
          end.each_with_index.map do |link, index|
            # get page link asynchronously
            page = index + 1
            image_request = Typhoeus::Request.new(link)
            image_request.on_complete do |res|
              puts "get page #{page}"
              puts res
              #image_parser = Nokogiri::HTML(response.body)
              #images[index] = image_parser.css('img#comic_page')[0]['src']
            end
            hydra.queue image_request
          end

          # run request
          hydra.run

          []
        end
      end
    end
  end
end

