# 理解基礎操作所需要的時間

要能夠進行效能最佳化之前、你必需先理解電腦系統裡、各種基礎操作所需要的時間

* 哪些操作是快的、我們要儘量多使用它們
* 哪些操作是慢地、我們要儘量避免使用

下面這個影片列出了 2020 年代 各項電腦系統中的基礎操作所需要的時間，我會建議你先好好的看一遍

*列出年代是因為電腦技術會變、以前很慢的操作會隨著技術改良而越來越快*

[![各種常見操作消耗時間(2020版)](https://img.youtube.com/vi/FqR5vESuKe0/0.jpg)](https://www.youtube.com/watch?v=FqR5vESuKe0)


底下也先節錄了裡面的重點內容方便查詢

|時間單位|英文全稱|實際時長|
|----|----|----|
|ns|nanosecond|十億分之一秒|
|us|microsecond|百萬分之一秒|
|ms|milisecond|千分之一秒|


|操作|耗時|
|----|----|
|CPU register|低於 1ns|
|CPU clock cycle|低於 1ns|
|CPU L1/L2 cache|1-10ns|
|某些比較 heavy 的 CPU 指令|1-10ns|
|CPU L3 cache|10-100ns|
|向系統發出 kernel 層級的呼叫(僅呼叫時間，不含時間底層執行時間)|100-1000ns|
|Thread context switching|1-10us|
|memcpy for 64KB data|1-10us|
|A http request through nginx|~50us|
|Reading 1MB data from main memroy|~50us|
|Reading 8KB page from SSD|~100us|
|SSD 寫入|100us~1000us|
|一般雲端環境內網|100us~1000us|
|一般 redis/memcachd 操作|1ms|
|一般雲端環境跨AZ網路|1-10ms|
|機械硬碟搜尋時間|~5ms|
|美東到美西網路傳輸|10-100ms|
|美東到歐洲網路傳輸|10-100ms|
|從主記憶體中循序讀取1GB資料|10-100ms|
|bcrypt|~300ms|
|TLS handshake|250ms~500ms|
|美西到新加坡網路傳輸|100-1000ms|
|從SSD中循序讀取1GB資料|100-1000ms|






