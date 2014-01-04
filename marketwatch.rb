require 'httpclient'
require 'nokogiri'
require 'json'
class MarketWatch
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
      if JSON.parse(resp.body)["result"] == "success"
        @c.save_cookie_store
        true
      end
    rescue
      false
    end
  end

  def get_rankings(gamename)
    # todo make this work. it doesn't
    url = "http://www.marketwatch.com/game/#{gamename}/ranking"
    #@c.debug_dev = STDOUT
    html = @c.get_content(url)
    page = Nokogiri::HTML(html)
    puts page
    ranking_section = page.css('.rankings').first
    puts ranking_section
    ranks = ranking_section.css('.tbody > tr > td.rank')
    rankings = []
    ranks.each do |rank|
      rankings << {
        rank: rank.text.strip,
        name: rank.parent.css('.name').first.text.strip
      }
    end
    rankings
  end
end
