require 'nokogiri'
require 'open-uri'

module API
  module V1
    class BatotoApi < Grape::API
      include API::V1::Defaults

      helpers do
        def current_user
          true
        end

        def authenticate!
          error!('401 Unauthorized', 401) unless current_user
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
      end
    end
  end
end

