# redis常用命令

### String
**设值** 
set key value

**读值(读取的key的值不存在会返回nil)**
get key

**读取后设置**
getset key value

**删除**
del key

**数值加1(如果这个key对应的值不存在，会在数据库内给这个key设置一个0的值，然后加1,如果key对应的值无法运输，返回错误信息)**
incr key 

**数值减1(如果这个key对应的值不存在，会在数据库内给这个key设置一个0的值，然后减1,如果key对应的值无法运输，返回错误信息)**
decr key

**数值指定加多少(如果这个key对应的值不存在，会在数据库内给这个key设置一个0的值，然后加几,如果key对应的值无法运输，返回错误信息)**
incrby key num(数值，增加多少)

**数值指定减多少(如果这个key对应的值不存在，会在数据库内给这个key设置一个0的值，然后减几,如果key对应的值无法运输，返回错误信息)**
incrby key num(数值，减少多少)

**给key值拼接数字同时返回这个新数值的长度，(如果拼接的key值为中文，一个汉字3位，如果这个key对应的值不存在，会在数据库内给这个key设置一个null，然后数值拼接在后面)**
append key num(数值，拼接在key值后面的数值)


### Hash(格式一点像 student: { name: 'LCN', password: '123' })
**设值** 
hset hashKey(通过这个key获取到这个hash) key(hash里面的键值对的key) value(键值对的值)

**同时设多个值** 
hmset hashKey key1 value1 key2 value2

**读值(读取的hasKey的值不存在会返回nil)**
hget hashKey key

**同时读取多个值** 
hmget hashKey key1 key2 

**获取所有的属性和属性值**
hgetall hashKey

**删除hash里面的值**
hdel hashKey key1(key2)

**直接删除一个hash**
hdel hasKey

**给hash里面的值指定加多少**
hincrby hashKey key num(数值)

**判断hash中某个值是否存在,存在返回1,不存在为0**
hexists hashKey key 

**获取hash中的key的个数**
hlen hashKey

**获取hash中所有的key**
hkeys hashKey

**获取hash中所有的value**
hvalues hashKey


### list
**在list的左侧添加数据，同时返回当前list的长度**
lpush listKey value1 value2 value3(结果为 value3 value2 value1) 

**在list的右侧添加数据，同时返回当前list的长度**
rpush listKey value1 value2 value3(结果为 value1 value2 value3) 

**查看list**
lrange listKey start end (start和end都可以为0或者负数，负数表示后面的第几个，-1倒数第一个，1，-1从第一个到倒数第一个)

**左侧删除，并返回删除值**
lpop listKey (原来 a,b,c 现在 b,c)

**右侧删除，并返回删除值**
rpop listKey (原来 a,b,c 现在 a,b)

**获取list的长度**
llen listkey

**获取对应的list是否存在，存在在其头部插入一个值，同时返回长度，不存在返回0**
lpushx listkey value

**获取对应的list是否存在，存在在其尾部插入一个值，同时返回长度，不存在返回0**
rpushx listkey value

**从list头部/尾部开始,删除几个什么**
lrem listkey num(几个) value （lrem listkey 2 3 删除2个3,当num为负的时候，表示从后面往前删除几个什么,当num为0，表示删除list中的所有什么 ）

**修改list某个位置的值**
lset listKey indexNum value (将list的第indexNum[索引从0开始]的值修改为value) 

**在list的某个元素的前面/后面添加什么**
linsert listKey before/after value newValue (在list的第一个/最后一个value前面添加一个newValue)

**删除某个list的最后一个，同时在另一个list的头部，添加这个value**
rpoplpush listKey1 listKey2


### set(和list类似，区别：不允许有重复的元素)
**向set添加元素**
sadd setKey value1 value2 value3(当value1,2,3有重复时，会去重，只是插入一个值时，重复会报错)

**删除set中指定的值**
srem setKey value1 value2 

**查看**
smembers setKey

**判断某个元素是否存在**
sismemeber setKey value (1为存在，0 不存在)

**求2个set的差集**
sdiff setKey1 setKey2 (去掉1,2都有的，显示只有1有的，当为setKey2 setKey1 则为只有2 有的，顺序有影响)

**求2个set的差集，并存放在另一个set中**
sdiffstore setKey1 setKey2 setKey3 (将2,3的差集放在1上)

**求2个set的交集**
sinter setKey1 setkey2(2个set同时都有的元素)

**求2个set的交集，并存在另一个set中**
sinterstore setKey1 setKey2 setKey3 (将2,3的交集放在1上)

**求2个set的并集**
sunion setKey1 setKey2 (将1,2合并为一个，同时去重)

**求2个set的并集，并存在另一个set中**
sunionstore setKey1 setKey2 setKey3 (将2,3的并集放在1上)

**获取set中元素的个数**
scard setKey

**随机返回set中的一个成员**
srandmember setKey


### Sorted-Set(和set类似，区别：Sorted-Set的成员在添加时需要制定一个分数，通过这些分数进行排序)
**添加元素**
zadd SortedSetKey score(分数) value score(分数) value（添加的元素已经存在，新的分数会替代旧的分数）

**获取某个元素的分数**
zscore SortedSetKey value

**获取Soreted-Set的数量**
zcare SortedSetKey

**删除某个元素**
zremove SortedSetKey value1 value2

**范围查找，按从小到大排**
zrange SortedSetKey start end withscore(可选，有的话会显示对应的元素的分数) 

**范围查找，按从大到小排**
zrevrange SortedSetKey start end withscore(可选，有的话会显示对应的元素的分数) 

**按照排名删除**
zremrangebyrank SortedSetKey start end(删除第start个到end个)

**按照分数删除**
zremrangebyscore SortedSetKey scoreStart scoreEnd (在scoreStart分到scoreEnd分之间)

**查询某个分数段的成员，并按照从小到大排列**
zrangebyrank/zrangebyscore SortedSetKey start end withscore limit indexNum1 indexNum2(显示第indexNum1到indexNum2)

**给某个元素的分数加分**
zincrby SortedSetKey score value(给value的分数添加score分)

**获取在某个范围分数内元素的个数**
zcount SortedSetKey scoreStart scoreEnd
