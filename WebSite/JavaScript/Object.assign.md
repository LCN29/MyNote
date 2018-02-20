# Object.assign
可以对对象进行拷贝，但是只能进行一级拷贝

#### Demo01
```js
  var obj1= { key: '值'};
  var obj2 = Object.assign({}, obj1);
  
  console.log(obj2.key);  //值
  
  obj2.key= "新的值";
  console.log(obj1.key);  //值
  console.log(obj2.key);	//新的值
```
`一级拷贝，将obj1拷贝到{}中，然后返回给obj2, 修改obj2，不会影响到obj1`

#### Demo02
```js
  var o1 = { a: 1 };
  var o2 = { b: 2 };
  var o3 = { c: 3 };
  
  var obj = Object.assign(o1, o2, o3);
  
  console.log(obj); // { a: 1, b: 2, c: 3 }
  console.log(o1); // { a: 1, b: 2, c: 3 }
  console.log(o2); 		// {b: 2}
  console.log(o3);		// {c: 3}
  
  obj.a= 2323;
  console.log(o1);  // { a: 2323, b: 2, c: 3 }
```
`将后面的参数合并到第一个参数，第一个参数改变，同时返回第一个参数(修改obj,o1改变)。当key值有相同的时候， 后面的覆盖前面的`

#### Demo03
```js
  var o1= { a: 1, b: 2};
  var o2= { b: 3};
  Object.assign(o1, o2);
  console.log(o1);    // {a: 1, b: 3}  o1的b被值被o2覆盖了，这很可怕的
  
  var o1= {
		person: {
			name: '名字',
			age: '年龄'
		}
	};

	var o2= {
		person: {
			sex: '性别',
		}
	};
  
  Object.assign(o1,o2);
  console.log(o1);  //  { person: { sex: '性别' } }  
  // 原本是想 给 person添加一个属性，结果覆盖，只剩下这个属性
  
  o1.person.name= "名字";
  o1.person.age= "年龄";
  console.log(o1);	//{sex: "性别", name: "名字", age: "年龄"}
  
  console.log(o2);	//{sex: "性别", name: "名字", age: "年龄"}
	//改变 o1的值，结果o2的值跟着改变  只做了一层拷贝，在深层的就是直接赋值了。
```

##### 使用格式
```js
 	var value= Object.assign(obj1,obj2...);
 	(1) obj1,obj2...  对象,可以很多个
 	(2) 返回值value: obj1
 	(3) 作用: 对象的合并和复制
 	但是其本身有很多问题，见demo02,demo03
```