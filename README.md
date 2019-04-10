# php-training-develop-env
PHPトレーニング向けローカル開発環境（PHP 5.6版）

## セットアップ
1. 依存関係のあるソフトウェアをインストール
  * VirtualBox 5.2.20 以上
  * Vagrant 2.2.0 以上

1. PHPトレーニング課題プロジェクトをClone
    ```console
    $ git clone https://github.com/haseo4423/php-training-question
    ```

1. このプロジェクトをClone
    ```console
    $ git clone https://github.com/haseo4423/php-training-develop-env
    $ cd php-training-develop-env
    ```

1. 設定ファイルの更新
    ```console
    $ vim vagrantfile
    ```
    ※`PHP_TRAINING_REPOSITORY_PATH`を自身の環境にCloneしたPHPトレーニング課題プロジェクトにあわせて変更

1. 起動
    ```console
    $ vagrant up
    ```
    ※初回起動から実際に使えるようになるには、1時間くらいかかる。

1. ブラウザでアクセスする
    `https://php5-training.dev.jp`にアクセスしてログイン画面が表示されたらセットアップ完了です。

## ログを見る方法
- `{このプロジェクトをCloneしたディレクトリ}/docker/log/`以下にログファイルが作成されます。

## 仮想サーバーへつなげる方法
1. Mac から CentOS に接続
    ```console
    % vagrant ssh
    ```

1. 各コンテナに接続
    ```console
    [vagrant@localhost ~]$ sudo su -
    [root@localhost ~]# cd /vagrant/docker/
    [root@localhost docker]# docker-compose exec ${コンテナ名} /bin/bash
    ```
    `${コンテナ名}`には、`sample`、`sample_db`のいずれかを設定

## postgreSQLにログインする方法
1. 上記方法で、`sample_db`に接続する。

1. postgreSQLログインコマンドを実行する。
    ```console
    $ psql -U php_training_user -d php_training_database
    ```

## トラブルシューティング

1. ブラウザからアクセスできないときは
  * `vagrant-hostsupdater`が動作していない可能性があります。以下を`hosts`に追加してください。
    ```text
    192.168.40.20	php5-training.dev.jp
    ```

## SSLエラーの回避方法
SSL証明書は、プライベート認証局(`[project_root]/docker/01_proxy/openssl/ca/sample-dev.cacrt.pem`)から発行したものです。  
そのため、`curl`やブラウザからアクセスする際、SSL証明書エラーが発生します。

回避方法としては、主に以下の2つがあります。
1. リクエストする際にSSLのエラーを無視するようにする。（`curl`の場合は、`-k`オプションをつける）
1. 認証局をPCに登録する

以下では、「認証局をPCに登録する」方法を説明します。

### プライベート認証局 登録方法（Macの場合）
1. `[project_root]/docker/01_proxy/openssl/ca/`ディレクトリをファインダーで開く
1. `sample-dev.cacrt.pem`をダブルクリックで開く  
    ⇒ `キーチェーン` が起動する
1. 管理者権限の `ユーザ名` `パスワード` を求められるので、入力する
1. `キーチェーン`アプリの`分類`の項目にある`証明書`をクリックする
1. `名前`が `sample-local5.dev.jp` のものを探し、ダブルクリックする
1. 表示された画面で`信頼`の左の三角をクリックし、「この証明書を使用するとき」の右のリストから`常に信頼`を選択する
1. 左上の赤いマークをクリックして画面を閉じる
1. 管理者権限の `ユーザ名` `パスワード` を求められるので、入力する

## デバッガーを使用するための設定
`sample`には、予め`Xdebug`をインストール済み。

IDEで設定を行うとデバッグが可能。

### デバッグポート
|  | ポート|
|:--|--:|
|sample|9002|

### ツールの設定（PhpStormの場合）
1. PhpStormの設定から、`Languages & Frameworks` ＞ `PHP` ＞ `Debug` を表示する。

1. `Xdebug`欄の'Debug Port'欄に上記のポート番号を入力し、`Apply`、`OK`を押す。

1. メイン画面の右上あたりにある「電話と虫」のアイコンをアクティブにする。

1. ブラウザから`https://php5-training.dev.jp/`にアクセスする。

1. PhpStorm側で接続許可のダイアログが出るので`accept`をクリックする。

これ以降、メイン画面の右上あたりにある「電話と虫」のアイコンで、デバックするか・しないかの切り替えが行える。

### ツールの設定（vscode・macの場合）
1. macのPHPをv7.x以上に更新する。

1. vscodeのデバッグパネルで`構成の追加` → `PHP`を選択する。

1. `launch.json`に以下を追記する。
```json
{
  "name": "Listen for XDebug",
  "type": "php",
  "request": "launch",
  "port": 9002,
  "serverSourceRoot": "/home/www/sample.dev.jp",
  "localSourceRoot": "${workspaceRoot}"
}
```

これ以降、vscode上でブレークポイントを設定し、デバッグモードにした状態でPHPを動作させると処理を止めることができます。
