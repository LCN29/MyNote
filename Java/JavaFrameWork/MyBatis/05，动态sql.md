# 05，动态sql

1. 正常的select
```xml
 <select id="findUserList" parameterType="userqueryvo" resultType="usercustom">
	SELECT * FROM user WHERE user.sex=#{userCustom.sex} AND user.address LIKE '%${address}%'
 </select>
  
```

2. 使用动态sql
```xml
  <select id="dynamicSQL" parameterType="userqueryvo" resultType="usercustom">
      SELECT * FROM user 
      <!-- 对传入的参数进行判断 -->
      <where>
        <!-- where 可以自动的去掉条件中的第一个and  -->
        
        <if test="userCustom!= null">
          <!--并关系 不能使用&& 使用 and代替  -->
          <if test="userCustom.sex!= null add userCustom.sex!= '' " >
            AND user.sex=#{userCustom.sex} 
          </if>
          <if test="address!= null and address!= '' ">
            AND user.address LIKE '%${address}%'
          </if>
        </if>
      </where>
  </select>
```

3. 如上sql的判断条件，可以单独抽出来，作为`SQL片段`，可以复用

**声明sql片段（sql便签和mapper同级）**
```xml
  <!-- 
	id：唯一标识
	经验：基于单表定义sql,这样重用性高  sql片段不要包含where
   -->
  <sql id="query_user_where">
	<if test="userCustom!= null">
		<if test="userCustom.sex!= null add userCustom.sex!= '' " >
			AND user.sex=#{userCustom.sex} 
		</if>
		<if test="address!= null and address!= '' ">
			AND user.address LIKE '%${address}%'
		</if>
	</if>
  </sql>
```

**调用sql片段**
```xml
  <select id="dynamicSQL" parameterType="userqueryvo" resultType="usercustom">
    <where>
     	<!-- 
		refid="sql片段的id" 
		如果引用的sql片段在其他文件，需要加上命名空间
	-->
	<include refid="query_user_where"></include>
    </where>
  </select>
```

**一个po的属性有数组或者List,向sql输入多个参数**

```java
  po对象UserQueryVo里面有
  ...
    private LIst<Integer> idList;
  ...
```

sql片段中

```xml
  <if test="idList!= null">
    <!-- 使用foreach遍历这个idList-->
    <!--
        collection: 对应的po对象需要遍历的属性名
        item: 遍历的每一项的别名
        open: 开始拼接时的串（使用时，不要忘记了还有一个and 拼接）
        close: 结束时拼接的串
        separator: 遍历的2个对象间需要拼接的串(list 里面的2项以什么分隔开)
        
        id in (10,20,8,7)
    -->
    <foreach collection="idList" item="item_id" open="and id in (" close=")"  separator=",">
	#{item_id}
    </foreach>
  </if>
```
