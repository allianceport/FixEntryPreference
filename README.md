FixEntryPreferenceプラグイン
=====================================

はじめに
--------

本プラグインは、エントリおよび、ウェブページの編集画面の、入力フィールドの表示項目と表示の順番を固定します。

インストール
------------

本パッケージに含まれる「**plugins**」ディレクトリ内のディレクトリ「FixEntryPreference」を、MovableTypeインストールディレクトリの「**plugins**」ディレクトリの下にコピーしてください。作業後、MovableTypeのシステム・メニューのプラグイン管理画面を表示し、プラグインの一覧に「FixEntryPreference」が表示されていることを確認してください。これで設置完了です。

使い方
------

1. 利用したいブログのサイドメニューの「ツール」\>「プラグイン」から「FixEntryPreference」の「設定」タブを開き、「enableの」チェックボックスをオンにします。
1. 個別の設定
    * 下記の項目を必要に応じて編集する。カスタムフィールドはベースネームに**customfield_**というプレフィックスをつける。

ユーザの権限\\編集対象| Entry | Page
---------------------|-------|-----|
Admin権限有あり| fix_admin_config_for_entry | fix_admin_config_for_page
Admin権限無し|fix_user_config_for_entry | fix_user_config_for_page

各要素のBasenameは下記となります。

要素名(テキストエリアに記載する)|エントリー(ページ)編集画面上の要素名
----|----
excerpt |概要
tags |タグ
keywords |キーワード
category |エントリー編集画面の右側のカテゴリー
folder | ページ編集画面の右側のフォルダ
feedback |右側のメニューのコメント
assets ||右側メニューのブログ記事アイテム
customfield_$BASENAME | カスタムフィールド


