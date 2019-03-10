# Object.defineProperty
属性赋值

#### Demo01
```js
var obj= {
  "test": "测试中..."
};
 
Object.defineProperty(obj,'add',{
  value: '添加值',
});

console.log(obj.add);  //添加值
```
`在obj对象里面添加了一个 add的属性，变成了 {“test": "....", "add": "..."}`


#### Demo02
```js
var obj= {
  "test": "测试中...",
  "a": "a",
  "b": "b",
};

Object.defineProperty(obj,'add',{
  value: '添加值',
  enumerable: true,
});

var arr= Object.keys(obj);
console.log(arr); // ["test","a","b",'add'] 
```
`在obj对象里面添加了一个 add的属性 设置了enumerable: true,表示该属性能通过for-in循环或Object.keys()返回属性`


#### Demo03
```js
var obj= {
  "test": "测试中...",
};

Object.defineProperty(obj,'add',{
  value: '添加值',
  writable: false,
});

console.log(obj.add); //添加值
obj.add="买买买";
console.log(obj.add); //添加值
```
`添加属性时，设置了writable: false, 后面无法对该值进行修改`


#### Demo04
```js
var obj= {
  "test": "测试中...",
};

Object.defineProperty(obj,'add',{
  value: '添加值',
  configurable: false,
});

delete obj.add;	//严格模式下，会报错
console.log(obj.add);	//添加值  delete不起作用

Object.defineProperty(obj,'add',{
  value: '添加值2',
  writable: true,
});		//报错
```
`configurable: false, 不能通过delete删除此属性,不能否修改属性的特性，不能把属性修改为访问器属性`

#### Demo05
```js
var obj ={
  "test": "测试中...",
}

var aValue,b,c;

Object.defineProperty(obj, 'name', {
  configurable: true,
  enumerable: true,
  get: function() {
    c= 123;
    return aValue;
  },
  set: function(newValue) {
    aValue = newValue;
    b = newValue + 1;
  }
});

console.log(obj.name);  //undefind
obj.name= 666;			
console.log(obj.name);	// 666
console.log(b);			//667
console.log(c);			//123
```
`给obj.name设值 会调用到set方法， 获值则会调用到get方法`


#### 格式
```js
  let result= Object.defineProperty(obj,key,descriptor);
  (1) obj: 需要变动的对象
		key： 变动的key
		descriptor: 修饰 非必须
		有2种格式,

		一， 数据属性
		{
			value: 任意数据类型， //默认值，undefind  效果见 eg1
			enumerable: boolean, // 默认值，false  效果见 eg2,
			writable: boolean,	//默认值，false  效果见 eg3
			configurable: boolean , //默认值 false, 效果见eg4
		},
		// 当writable:false 但是 configurable: true  可以通过
		// Object.defineProperty重新赋值

		二，访问器属性(作用：数据绑定)
		{
			configurable: boolean,		// 为了能使用访问器模式，该值为true
		    enumerable: boolean,
		    get: function() {
		        return aValue;   // 每次obj.key 会调用这个方法，同时返回aValue
		    },
		    set: function(newValue) {
		        aValue = newValue; // 每次给obj.key设值，调用这个方法
		    }
		}
    
  (2) 返回值： 返回新的对象	

  (3) 作用: 总的来说就是给对象修改属性
```

#### 补充1 如果一次性想要修改多个值，可以使用  Object.defineProperties()	

```js
Object.defineProperties()；

Object.defineProperties(obj,{
  name: {
    value: '张三',
    configurable: false,
    writable: true,
    enumerable: true
},
  age: {
    value: 18,
    configurable: true
  }
});
```

#### 补充2 如果需要获取某个的修饰，可以通过 Object.getOwnPropertyDescriptor

```js
var desc = Object.getOwnPropertyDescriptor(obj,'key值');
console.log(des); // { configurable: true, enumerable: true,....}  

要获取多个
Object. getOwnPropertyDescriptors(obj);
```