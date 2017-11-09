  #shell command
require 'shell'
  #git command
require 'git'
  #scraping
require 'nokogiri'
require 'open-uri'

#define 
WORKINGDIR = '~/qiita'
  #日時を取得
DATE = Date.today.to_s.gsub('-','')

def get_doc
  url = 'https://qiita.com/popular-items'
  charset = nil
  html = open(url) do |f|
     charset = f.charset # 文字種別を取得
     f.read # htmlを読み込んで変数htmlに渡す
  end
  return  document = Nokogiri::HTML.parse(html, nil, charset)
end

# #---------------------------------------------------
#scraping
doc = get_doc
rootURL = 'http://qiita.com'

return_text = ''
doc.xpath("//a[@class='popularItem_articleTitle_text']").each do |element|
  ele = Hash.new
  ele[:href] = rootURL +  element['href']
  ele[:text] = element.xpath('span').text
  text= "- [ ] [#{ele[:text]}](#{ele[:href]})"
  #md linkサンプル [姫路IT系勉強会](http://histudy.doorkeeper.jp/)
  return_text += "#{text} \n"
end
# # 書き込み処理 #-------------------------------------------------

# #shell
sh = Shell.new
sh.mkdir("#{WORKINGDIR}") unless sh.exists?("#{WORKINGDIR}")

sh.cd("#{WORKINGDIR}") do
  f = sh.open("#{DATE}.md", "w")
  f.puts return_text
  f.close
end

repo = Git.open(WORKINGDIR)
repo.add(".")
repo.commit("#{DATE}'s qiita trends")
repo.push