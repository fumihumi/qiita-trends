  #shell command
require 'shell'
  #git
require 'grit'
require 'rugged'
  #scraping
require 'nokogiri'
require 'open-uri'

#define
WORKINGDIR = '~/qiita'
  #日時を取得
DATE =Date.today.to_s

def get_doc
  url = 'https://qiita.com/popular-items'
  charset = nil
  html = open(url) do |f|
     charset = f.charset # 文字種別を取得
     f.read # htmlを読み込んで変数htmlに渡す
  end
  return  doc = Nokogiri::HTML.parse(html, nil, charset)
end

# #main script
sh = Shell.new
sh.mkdir("~/qiita") unless sh.exists?("~/qiita")

# #---------------------------------------------------
#scraping
doc = get_doc
rootURL = 'http://qiita.com'

return_text = ''
doc.xpath("//a[@class='popularItem_articleTitle_text']").each do |element|
  ele = Hash.new
  ele[:href] =rootURL +  element['href']
  ele[:text] = element.xpath('span').text
  text= "- [ ] [#{ele[:text]}](#{ele[:href]})"
  # [姫路IT系勉強会](http://histudy.doorkeeper.jp/)

  return_text += "#{text} \n"
end

# # #-------------------------------------------------
sh.cd("~/qiita") do
  f = sh.open("#{DATE}.md", "w")
  f.puts return_text
  f.close
end

repo = Grit::Repo.new("~/qiita") #レポジトリオブジェクトを生成
blob = Grit::Blob.create(repo, {:name => "#{DATE}.md", :data => File.read("#{DATE}.md")})
# # git add && commit
Dir.chdir(repo.working_dir) { repo.add(blob.name) }
repo.commit_index("#{DATE}'s qiita-feed")



#------pushしたい人生
# remote = repo.remotes.last
# repo.git.push({}, remote)
# repo.git.push( {} , 'qiita-trends' , 'master')
#
# repo = Rugged::Repository.new('./')
#
#
# repo.push('git@github.com:fumihumi/qiita-trends.git')
