require "marketwatch/client/version"
require 'httpclient'
require 'nokogiri'
require 'json'

module Marketwatch
  class Client
    def initialize
      @c = HTTPClient.new
      @c.set_cookie_store("./cookie.jar")
    end

    def login(username, password)
      body = {
        username: username,
        password: password,
        url: "http://www.marketwatch.com/",
        template: "default",
        realm: "default",
        savelogin: "true"
      }.to_json
      resp = @c.post('https://id.marketwatch.com/auth/submitlogin.json', body, {'Content-Type' => "application/json; charset=UTF-8"})
      begin
        jsresp = JSON.parse(resp.body)
      rescue
        return false
      end
      unless jsresp["result"] == "success" && jsresp["url"]
        return false
      end

      resp = @c.get(jsresp["url"])
      resp.status == 200 || resp.status == 302
    end

    def get_rankings(gamename)
      url = "http://www.marketwatch.com/game/#{gamename}/ranking"
      html = @c.get_content(url)
      page = Nokogiri::HTML(html)
      ranking_section = page.css('.rankings').first
      ranks = ranking_section.css('tbody > tr > td.rank')
      rankings = []
      ranks.each do |rank|
        rankings << {
          rank: rank.text.strip,
          name: rank.parent.css('.name').first.text.strip,
          money: rank.parent.css("td:nth-child(3)").text.strip
        }
      end
      rankings
    end
  end
end
