# Object.key
获取对象的key值，如果是数组，则返回索引

#### Demo01
```js
var arr= ['a','b','c'];
var result= Object.keys(arr);
// result=== ['1','2','3']
```

```js
var jsop= {
  "a": "aa",
  "b": "bb",
  "c": "cc"
};
var result= Object.keys(jsop);
//result=== ['a','b','c']
```

#### 格式
```js
  var value= Object.keys(arg);

 (1) arg: array/object
 (2) 返回值 value: array	

```