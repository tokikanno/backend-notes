# 為什麼要使用 cache?

根據我們在[理解各種操作消耗的時間](optimization/operation-costs.md)這篇文章裡的資訊
從系統記憶體讀取 64 KB 的資料大概只需要 1-10us，如果你所需要的資料都可以在主記憶體中取得的話、操作上一定是相對快的

# 什麼時候會使用 cache?

通常你的程式中操作符合下面所有的特徵時、你就可以考慮將運算的結果暫時存在記憶體中作為快取

* 程式產出運算結果的時間較長
* 後續會多次使用到這個運算結果
* 資料的更新頻率較低(如果這秒產出、下一秒資料又要重新更新、那就不合適)
* 後續使用到這個運算結果的時候、可以一定程度上容忍資料不是最新的版本

# 既然主記憶體那麼快，為什麼我們還需要 redis/memcached 這類 cache server?

因為在大型系統裡、通常你不會只有一台主機需要存取 cache。
為了在各主機之間同步 cache 內的資料並且共用、所以我們會需要這類 cache server。

如果你能精確的控制各台主機同步更新 local cache 的內容，或是你的程式對於 cache 內容的同步和即時性的要求並不高。
那麼你也可以考慮使用各台主機的記憶體作為 local cache。

# 如果我需要 cache 的資料超過了 cache server 的記憶體大小怎麼辦?

~~加記憶體~~(誤)

如果是單筆資料大小超過 cache server 主記憶體大小，你可能需要先問問自己你的資料為何會這麼大。
一般正常 cache server 並不是設計用來儲存這麼大型的資料的（而是相對多筆的小資料）。

如果你的需要 cache 小資料因為某些原因（例如: 你的 user 有像 fb/twitter 這麼多）
那麼你可能需要的使用 redis cluster/twmemproxy 之類的解決方案來使用多個 cache server 組成一個大的 cache cluster

# 這類 cache cluster 是如何分配資料該去哪一台主機的?

為了讓資料平均分佈、通常會用資料的 key 做 hash 後作為分配依據。
但是這邊要注意的是、一般這類 cache cluster 會搭配上 [consistent hashing](https://zh.wikipedia.org/wiki/%E4%B8%80%E8%87%B4%E5%93%88%E5%B8%8C) 這類的技術讓新增移除 cluster 內的節點時候不需要移動全部資料。

# Cache miss storm

一般我們在使用 cache 的時候，通常會用類似下面的 pattern 操作
先嘗試從 cache 中讀取資料，如果讀不到資料的話、再真的去取得資料
這時候除了回傳取得的資料之外、會再順便將資料存入 cache 中讓後續的資料取得更快速


```python
def get_data() -> dict:
    # try get from cache first
    result = cache.get(CACHE_KEY)
    if result is not None:
        return result

    # call the real_get_data() function
    result = real_get_data()

    # set it back to cache
    cache.set(CACHE_KEY, result, CACHE_TIMEOUT)

    return result
```

但由於會使用 cache 的地方通常都是熱門的節點。一旦 cache 失效的瞬間、就會有大量的節點同時嘗試去更新 cache。
如果被 cache 包裹的程式運算相對的 heavy 的時候，有可能會因為同時間有大量這類運算湧入而導致 server 被瞬間擊潰。

這種情形我們通常稱為 cache miss storm 或是 cache stampede

相關的解決方式可以參考[這篇 blog](https://www.percona.com/blog/2010/09/10/cache-miss-storm/)
