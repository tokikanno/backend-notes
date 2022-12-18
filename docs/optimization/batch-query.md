# 批次存取

批次存取這個優化對應的問題、通常會出現在報表類的程式上。因爲報表類的東西通常需要存取大範圍的資料。

擧個例子來説: 你老闆要你生出全站商品的詳細資料報表

很多工程師就會很直覺的

```python
rows = db.execute('select * from products')

for r in rows:
	# convert row data into report format ....
```

如果你的開發環境 DB 只有幾十個 row 的時候、這個操作可能還好

但是當你的 production DB 有幾十萬個 row 的時候、通常很快你的 DBA 或是老闆就會來問候你了。因爲上面的 query 會慢到爆炸、它一次要拉出太多東西了，你的 DB server 如果系統資源不是很多的話，會被這個 query 占據很大一部分的處理效能。

於是比較有經驗一點的工程師會用 skip + limit 的方式分段把資料取出來、讓每次需要吐回的資料不至於太大

```python
LIMIT = 1000

skip = 0

while True:
	rows = db.execute(
		'select * from products limit %s, %s'
		(skip, LIMIT)
	)

	for r in rows:
        # convert row data into report format ....

	# check if no more to fetch
    if len(rows) != LIMIT:
		break

	skip += LIMIT
```

但是，這個方式大概只能應付到幾十萬個 row、如果你有數百萬或是上千萬的 row 的時候、對不起、你的老闆或是 DBA 可能又要來找你了。

因爲通常資料庫的 skip 實作、其實内部還是要實際掃過你 skip 的 row 之後才能正確的把後續的資料抓出來。既然它要先實際掃過被 skip 的 row，你 skip 越多 row 的時候、你就會越接近 full table scan (跟越接近被 DBA 或是老闆抓去揍)。

那麽要怎麽辦呢? 跟老闆說做不了嗎?

其實也不會、這個問題還是有解決方法的、前提是你的 query 結果裏頭有一個帶 index 的 unique key 可以使用。

我們假設 products table 的 primary key 是 pid

```python
LIMIT = 1000
current_key = ''

while True:
	rows = db.execute(
		'select * from products where pid > current_key order by pid limit %s'
		(current_key, LIMIT)
	)

	for r in rows:
        # convert row data into report format ....

	# check if no more to fetch
    if len(rows) != LIMIT:
		break

	# use unique key from last row as next starting point
	current_key = rows[-1]['pid']
```

基本上原理就是、利用 index 可以快速排序及定位某一筆資料的特性、先讓 query 的結果依照該 key 排序。並且利用查詢結果最後一筆該 key 的值、作爲下一次查詢的起始定位點。這樣就可以讓資料庫在下一筆查詢的時候直接由定位點開始往下找、而不是要呆呆的 skip 前面所有的 row 之後再開始吐資料。

不過呢，這邊還是會有一些衍生的問題產生、例如：你的老闆很堅持你要用上架時間作爲順序產生報表、這個時候又該怎麽辦呢? 這個話題就留給看到這篇文章的人自己當練習題試試看嘍。
