# 資料結構/演算法

其實不管你是前端、後端、甚至是資料工程師，資料結構和演算法都對你很重要。
因為只要你在寫程式的時候、你幾乎無時無刻都會用到它們。

要掌握它們最好的方式、就是~~去刷 [leetcode](https://leetcode.com/)~~理解你寫的每一行程式、對於時間複雜度以及空間複雜度所造成的影響。

在這邊先暫停一下，如果你還不知道什麼是[時間複雜度](https://zh.wikipedia.org/zh-tw/%E6%97%B6%E9%97%B4%E5%A4%8D%E6%9D%82%E5%BA%A6)或是[空間複雜度](https://zh.wikipedia.org/zh-tw/%E7%A9%BA%E9%97%B4%E5%A4%8D%E6%9D%82%E5%BA%A6)的。我會建議你先去搞懂之後再繼續你的工程師之旅。

# 為什麼你需要資料結構和演算法

因為這些前人思考了非常久的智慧結晶能讓你的程式更有效率、也更快。

讓我們來看一個簡單的例子

```python
# 給定一個陣列(array) USERS、裡面是一群使用者的資料、請找出使用者 id 為 3 的那筆使用者資料並且回傳

USERS = [
    {'id': 1, 'name': 'John', 'age': 30},
    {'id': 2, 'name': 'Mary', 'age': 24},
    {'id': 3, 'name': 'Steven', 'age': 45},
    {'id': 4, 'name': 'Jack', 'age': 12},
    {'id': 5, 'name': 'Sandy', 'age': 17},
    # ... more
]
```

這時候最直觀的方式、就是把這個 list 從頭到尾 loop 一次去比對每一筆資料、直到我們比對出符合條件的那筆資料。

```python
def find_user(user_id: str) -> Optional[dict]:
    for u in USERS:
        if u['id'] == user_id:
            found_user = u
```

那麼 find_user 這個 function 操作的效率如何呢?

**時間複雜度為 `O(n)`**

因為最糟的情形、你必須要走完這個陣列、才能夠確定 ID 為 3 的使用者資料是否存在。

**空間複雜度為 `O(1)`**

因為不管 USERS 多大、你都不需要額外的空間去處理它

---

但是如果你有學過資料結構（並且還沒有還給老師的話）、你應該會記得一種叫做 hash table (或是 dictionary) 的資料結構。於是我們便有了第二版的程式。

```python
# 先 loop USERS array 並建立一個 user id 對 user dict 的對應表
# 請注意、這個變數的位置是在 find_user 的外面而不是裡面
USER_ID_MAP: dict[str, dict] = {u['id']: u for u in USERS}

def find_user(user_id: str) -> Optional[dict]:
    return USER_ID_MAP.get(user_id)
```

這時候 find_user 這個 function

**時間複雜度為 `O(1)`**

因為在 dictionay (has table) 中、找到特定值的這個操作的時間複雜度為 O(1)

**空間複雜度為 `O(n)`**

因為相對於 USERS 裡的每一筆紀錄、你都會需要以 id 作為索引值在 dictionary (hash table) 中建立一筆紀錄

也就是相對的使用空間換取了時間。但是通常電腦程式在執行的時候、CPU 資源比記憶體等資源更為珍貴、所以這樣子的交換通常是被鼓勵的。

---

那麼、有沒有可能有使用了資料結構、卻反而比較慢的情形出現? 有的、但是通常是因為使用場景特殊或是你的程式寫太爛。

例如、如果你把上面的程式寫成這樣

```python
def find_user(user_id: str) -> Optional[dict]:
    # 把產生 USER_ID_MAP 的程式移動到 function 裡
    USER_ID_MAP: dict[str, dict] = {u['id']: u for u in USERS} # O(n)
    return USER_ID_MAP.get(user_id) # O(1)
```

這等於你每次呼叫 find_user() 這個 function 的時候、都會重新建立一次 USER_ID_MAP 這個 dictionary。這是一個（沒有任何機會提早結束迴圈的）的時間複雜度為 O(n) 的操作。

並且你最後還要再`多`做一個 `USER_ID_MAP.get(user_id)` 的操作（雖然它是 O(1))

相比把整個陣列 loop 一次的時間複雜度`最糟`就是O(n)，而且它還有機會提早結束（只要找到符合的紀錄就可以 break 了）。這就會造成使用了比較快的資料結構卻反而還比較慢的情形。

那麼現實中有沒有可能出現這種場景呢? 的確是有的，如果你的 USERS 陣列裡的資料、在你每次需要執行 find_user 時、裡面的內容都不一樣的話、你就會（被迫）寫出等效於上面的程式（每次都需要重新建立 dictionary）。這時候使用資料結構、反而還不如使用最笨的方式去查詢來的有效率。

# 補充思考

如果題目改成下面、你會怎麼思考?

```python
# 給定一個陣列(array) ARTICLES、裡面是一群使用者的資料、請找出「所有」作者 id 為 3 的文章資料並且回傳

ARTICLES = [
    {'id': 1, 'author_id': 3, 'title': 'xxxx'},
    {'id': 2, 'author_id': 3, 'title': 'yyyy'},
    {'id': 3, 'author_id': 4, 'title': 'zzzz'},
    {'id': 4, 'author_id': 5, 'title': 'jjjj'},
    {'id': 5, 'author_id': 6, 'title': 'kkkk'},
    # ... more
]
```
