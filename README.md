# Mattermost docker image using N-gram parser

## History

> 2018-07-29  
> mattermost-preview 5.x に対応

## What's this ?

Mattermost を日本語で利用するときに必ず課題となるのが日本語文書の部分検索。  
その解決策としてパーサーに N-gram を使うことはよく知られているが、[Mattermost-preview](https://hub.docker.com/r/mattermost/mattermost-preview) をベースに `docker run` コマンド一発で日本語対応の Mattermost 環境を構築できるように改変したのが、この Docker Image。

## Improvement

### Overview

Docker ユーザーなら、`docker run` コマンド一発で実行環境を構築したいと思うもの。だが、本家の Mattermost Docker Image を使って N-gram パーサー対応しようとすると、`docker run` でコンテナを実行してからシェルに接続して、mysql で SQL コマンドを実行といった手順を踏む必要がある。  
（理由： My SQL が動作し、Mattermost DB 構築された後でないとインデックスを再構築できないため）

最初は、Dockerfile の改変だけで実現できるかと思ったが、ベースのイメージ内では Mattermost DB が構築されておらず、Matttermost の起動コマンド内で DB 構築しているため、`ENTRYPOINT` に指定してあるスクリプトも改変している。

### Summary

* My SQL の文字コードを UTF-8 に変更
* Mattermost の起動を wget でポーリング待ちしてから、My SQL のインデックスを N-gram パーサーで再構築
* Mattermost のコンフィグファイルをボリュームの対象ディレクトリにコピーして使用
* mattermost-data ボリュームの対象ディレクトリのパスを修正
* Mattermost 標準の CLI コマンド(bin/mattermost) を /usr/local/bin にシンボリックリンク

## Usage

当然ながら、使い方の基本は [mattermost-preview](https://docs.mattermost.com/install/docker-local-machine.html) と同じ。

```
docker run -d -p 8065:8065 --restart always --name mattermost k1tajima/mattermost_ngram
```

唯一、改良して点は、コンフィグファイルを外部ボリュームに保存できるように、config ディレクトリを `mattermost-data` ディレクトリ以下にコピーして使用していること。

仕掛けは Dockerfile で `ENTRYPOINT` に指定してあるスクリプトの次の箇所。

> [docker-entry_ngram.sh#L20](https://github.com/tajimak/mattermost_ngram/blob/603956ac118615e6a069ddfea4fcc429d8009003/docker-entry_ngram.sh#L20) 

単純に `mattermost/config` ディレクトリを外部ボリュームにマウントすると、はじめて実行するときはコンフィグファイルが存在せず失敗してしまう。  
なので、`copy -rn` コマンドでファイルが存在しない場合のみ、オリジナルのコンフィグファイルをテンプレートとしてコピーしている。

この改良により、下記コマンドのように `/mm/mattermost/mattermost-data` ディレクトリをマウントするだけで、コンフィグファイルも外部ボリュームに保存され、コンテナの再構築時にも元のコンフィグを再利用できる。

```
docker run -d -p 8065:8065 --restart always -v c:/docker-share/mattermost/data:/mm/mattermost/mattermost-data -v c:/docker-share/mattermost/mysql:/var/lib/mysql --name mattermost k1tajima/mattermost_ngram
```

## References

* [Mattermost(v2.1.0)の日本語メッセージ全文検索をMySQL 5.7の標準ngramパーサを使い暫定対応](https://qiita.com/terukizm/items/b477943b63c66ab7d454)

* 本家: [mattermost/mattermost-docker-preview の GitHub](https://github.com/mattermost/mattermost-docker-preview)

All the best,
k1tajima
