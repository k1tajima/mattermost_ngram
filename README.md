# Mattermost docker image using N-gram parser

## History

* 2018-10-27
  * mattermost-preview: latest に追従。
  * 現時点の最新タグ: 5.4.0

* 2018-10-06
  * config ディレクトリを元の /mm/mattermost/config に戻し、ボリュームとして明示。
  * 空の config ディレクトリをボリュームマウントした場合にも既定の config ファイルがコピーされて動作するように変更。
  * パスに /mm/mattermost/bin を追加。

* 2018-07-29
  * mattermost-preview 5.x に対応

## What's this ?

Mattermost を日本語で利用するときに必ず課題となるのが日本語文書の部分検索。  
その解決策としてパーサーに N-gram を使うことはよく知られているが、[mattermost-preview][mattermost-preview-image] をベースに `docker run` コマンド一発で日本語対応の Mattermost 環境を構築できるように改変したのが、この Docker Image。

[mattermost-preview-image]:https://hub.docker.com/r/mattermost/mattermost-preview

## Improvement

### Overview

Docker ユーザーなら、`docker run` コマンド一発で実行環境を構築したいと思うもの。
だが、本家の Mattermost Docker Image を使って N-gram パーサー対応しようとすると、`docker run` でコンテナを実行してからシェルに接続して、mysql で SQL コマンドを実行といった手順を踏む必要がある。  
（理由： My SQL が動作し、Mattermost DB 構築された後でないとインデックスを再構築できないため）

最初は、Dockerfile の改変だけで実現できるかと思ったが、ベースのイメージ内では Mattermost DB が構築されておらず、Matttermost の起動コマンド内で DB 構築しているため、`ENTRYPOINT` に指定してあるスクリプトも改変している。

### Summary

* My SQL の文字コードを UTF-8 に変更
* Mattermost の起動を wget でポーリング待ちしてから、My SQL のインデックスを N-gram パーサーで再構築
* mattermost/config ディレクトリをボリュームとして登録し、
  空の config ディレクトリをマウントした場合は既定のコンフィグファイルをコピーして動作するように変更
* mattermost-data ボリュームの対象ディレクトリのパスを修正
* Mattermost/bin ディレクトリをパスに追加

## Usage

当然ながら、使い方の基本は mattermost-preview と同じ。

> 参照: [Docs > Administrator’s Guide > Local Machine Setup using Docker][mattermost-preview-install]

[mattermost-preview-install]:https://docs.mattermost.com/install/docker-local-machine.html

唯一の改良点は、はじめて実行時に空の config ディレクトリをマウントした場合でも既定の config が適用されて動作するようにしてあること。

仕掛けは Dockerfile で `ENTRYPOINT` に指定してあるスクリプトの次の箇所。

> [docker-entry_ngram.sh#L23](https://github.com/tajimak/mattermost_ngram/blob/master/docker-entry_ngram.sh#L23) 
> ```sh
> cp -nrp ./config_init/* ./config/
> ```

オリジナルの mattermost-preview で単純に `mattermost/config` ディレクトリに空のホストディレクトリをマウントすると、必要なコンフィグファイルが存在しないために失敗してしまう。  
なので、`copy -nrp` コマンドでファイルが存在しない場合には、オリジナルのコンフィグファイル[^1]をテンプレートとしてコピーしている。

[^1]: [DockerFile](https://github.com/tajimak/mattermost_ngram/blob/master/Dockerfile#L15) で `./config_init/` ディレクトリにコピー済み。

```sh
docker run -d -p 8065:8065 --restart always -v c:/docker-share/mattermost/config:/mm/mattermost/config -v c:/docker-share/mattermost/mattermost-data:/mm/mattermost/mattermost-data -v c:/docker-share/mattermost/mysql:/var/lib/mysql --name mattermost k1tajima/mattermost_ngram
```

## References

* [Mattermost(v2.1.0)の日本語メッセージ全文検索をMySQL 5.7の標準ngramパーサを使い暫定対応](https://qiita.com/terukizm/items/b477943b63c66ab7d454)

* 本家: [mattermost/mattermost-docker-preview の GitHub](https://github.com/mattermost/mattermost-docker-preview)

All the best,
k1tajima
