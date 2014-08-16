require 'nokogiri'
require 'net/http'
require 'eventmachine'
require 'open-uri'
require 'uri'

module API
  module V1
    class KissMangaApi < Grape::API
      include API::V1::Defaults

      helpers do
        def logger
          KissMangaApi.logger
        end

        def get_link link
          {:type => link.css("img")[0]["class"], :link => link["href"]}
        end
      end

      # GET /api/v1/kissmanga
      resource :kissmanga do
        # GET /api/v1/kissmanga
        desc "get manga with the name"
        get "/:name" do

          # query
          data = {
            :mangaName => params[:name],
            :authorArtist => "",
            :status => "",
            :genres => [0] * 40
          }
          doc = Nokogiri::HTML(
            Net::HTTP.post_form(URI.parse("http://kissmanga.com/AdvanceSearch"), data).body
          )

          # Search for nodes by css
          links = []
          doc.css("div#leftside table.listing tr").each do |tr|
            begin
              link = tr.css("td")[0].css("a")[0]
              links << {:title => link.content, :href => "http://kissmanga.com#{link["href"]}"}
            rescue
              # TODO
              # not found the link or not the link you want to select
            end
          end
          links
        end

        desc "get manga main page"
        params do
          requires :link, type: String, desc: "Page link"
        end
        post "/" do
          doc = Nokogiri::HTML(open(params[:link]))
          image = doc.css("div#rightside div.barContent")[0].css("img")[0]['src']
          chapters = []

          doc.css('table.listing tr').map do |tr|
            begin
              link = tr.css("td")[0].css("a")[0]
              chapters << {:href => "http://kissmanga.com#{link["href"]}", :title => link.content}
            rescue
              # TODO
              # not found the link or not the link you want to select
            end
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
          prev_link = nil
          next_link = nil
          chapter_name = ""
          doc.css("select.selectChapter")[0].css("option").each do |option|
            if option[:selected] == "selected"
              chapter_name = option.content
              break
            end
          end

          doc.css("div[style='float: left; padding-left: 20px'] a").each do |chapter_link|
            obj = get_link(chapter_link)
            if obj[:type] == "btnPrevious"
              prev_link = obj[:link]
            else
              next_link = obj[:link]
            end
          end

          doc.css("script").each do |script|
            script.content.scan(/lstImages.push\(".+?"\)/).each do |image|
              image.slice! "lstImages.push(\""
              image.slice! "\")"
              images << image
            end
          end

          chapters = []
          root_url = doc.css("#navsubbar p a")[0][:href]
          doc.css(".selectChapter option").each do |option|
            content = {
              :value => root_url + "/" + option[:value],
              :title => option.content.strip
            }
            if option[:selected] == "selected"
              content[:selected] = true
            end
            chapters << content
          end

          {
            :prev => prev_link,
            :next => next_link,
            :title => chapter_name,
            :images => images,
            :chapters => chapters
          }
        end
      end
    end
  end
end
