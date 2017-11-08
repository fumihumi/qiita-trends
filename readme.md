## qiita-trendsとは。  
- １日一回qiitaの[トレンド](https://qiita.com/popular-items)を取得するプログラム

### how to 
下記のgemを利用しているため、  
bundle list にて下記を確認する必要がある。
```  
  #shell command
require 'shell'
  #git
require 'git'
  #scraping
require 'nokogiri'
require 'open-uri'
```  
> source codeについて   

WORKINGDIR = '~/qiita'  
-> この定数は取得してきたqiita's-trendをどのディレクトリに保存するのかをさしています。
defaultでは。{/Users/"username"/qiita}配下に作成するようになってるので適宜変更してみてください。

DATE = Date.today.to_s.gsub('-','')  
保存するファイル名は" #{DATE}.md "というスタイル （20171108.md）のようになっているスタイルを変える場合は、strftimeを使うことを推奨

get_docメソッドによって、(https://qiita.com/popular-items)ここにアクセスし、parseしている。
その後parseした'変数doc'にたいしxpathを利用し、欲しいデータ(trend投稿)にアクセスし、タイトルと、リンクを取得している

40行目以降の処理では、  
Shellのインスタンスを作成し、workingdirがなければ新規に作成を試みます  
→git init必須

最後の四行はgit add && commit && pushの流れです。
```
repo = Git.open(WORKINGDIR)
repo.add(".")
repo.commit("#{DATE}'s qiita trends")
repo.push
``` 
