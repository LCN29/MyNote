# 03， MyBatic开发dao

## 原始dao开发

步骤
1. 声明dao接口
2. 实现dao接口

接口
```java
  public interface UserDao {
    //根据id查找用户
    public User findUserById(int id) throws Exception;

    //添加用户
    public void insertUser(User user) throws Exception;

    //删除用户
    public void deleteUser(int id) throws Exception;
  }
```

实现类
```java
  public class UserDaoImpl implements UserDao{
  
    private SqlSessionFactory sqlSessionFactory;
    
    //sqlsession 之所以不单独设置为属性，是为了线程安全，
	
    public UserDaoImpl(SqlSessionFactory sqlSessionFactory){
      this.sqlSessionFactory= sqlSessionFactory;
    }
    
    @Override
    public User findUserById(int id) throws Exception {
      // TODO Auto-generated method stub

      SqlSession sqlSession= sqlSessionFactory.openSession();
      User user=sqlSession.selectOne("user.findUserById", id);
      System.out.print(user.toString());
      //释放资源
      sqlSession.close();

      return user;
    }

    @Override
    public void insertUser(User user) throws Exception {

      SqlSession sqlSession= sqlSessionFactory.openSession();
      sqlSession.insert("user.addUser", user);
      //提交事务
      sqlSession.commit();
      sqlSession.close();
      System.out.println(user.getId());
    }

    @Override
    public void deleteUser(int id) throws Exception {
      // TODO Auto-generated method stub
      SqlSession sqlSession= sqlSessionFactory.openSession();
      sqlSession.delete("user.deleteUser", id);
      //提交事务
      sqlSession.commit();
      sqlSession.close();
    }
  }
```

使用
```java
  try {
    String sqlMapConfig= "SqlMapConfig.xml";
    InputStream inputStream = Resources.getResourceAsStream(sqlMapConfig);
    sqlSessionFactory= new SqlSessionFactoryBuilder().build(inputStream);
  } catch (IOException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
  
  UserDaoImpl impl= new UserDaoImpl(sqlSessionFactory);
  User user= new User();
  user.setAddress("香港");
  user.setBirthday(new Date());
  user.setSex("女");
  user.setUsername("李玲");

  try {
    impl.insertUser(user);
  } catch (Exception e) {
    e.printStackTrace();
  }
```

### 原始开发dao的方法问题总结
1. dao接口实现类中，存在大量的代码重复如，sql连接，提交，断开
2. 在调用sqlsessiont方法时，将statement的id硬编码了,如 user.findUserById
3. sqlsessiont方法，使用泛型,在编译阶段，也不报错,不利于开发

## mapper代理
步骤
1. 编写mapper接口(相当于dao接口),中间需要遵循一些规范
2. 编写mapper.xml的映射文件
3. 基于上面2步，mybatis可以自动生成mapper接口实现类的代理对象

遵循的规范
1. mapper.xml 的 namespace等于mapper接口的地址
2. 接口的方法名需要和mapper.xml中的sql语句的id一致
3. 接口的方法名的参数需要和mapper.xml中sql语句的parameterType类型一致
4. 接口的方法的返回值和mapper.xml的resultType的类型一致

mapper接口
```java
  public interface UserMapper {
	  //根据id查找用户
	  public User findUserById(int id) throws Exception;
    
    //注意此处返回的是List,在看一下mapper.xml对应的的resultTyper 返回的是User
    //myBatis会根据方法的返回值，自动选择 selectOne,还是selectList,所以resultType
    //不需要配置成List,正常的返回User就行了，代码自动返回List
    public List<User> findUsersByUserName(String username) throws Exception;
    
  }
  
```
mapper.xml
```xml
  <?xml version="1.0" encoding="UTF-8" ?>
  <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <mapper namespace="com.example.mapper.UserMapper">
      <!-- 通过id查询用户 -->
      <select id="findUserById" parameterType="int"   resultType="com.exampel.po.User">
        SELECT * FROM USER WHERE id=#{id}
      </select>
      
      <!-- 通过用户名模糊匹配  -->
      <select id="findUsersByUserName" parameterType="java.lang.String" resultType="com.exampel.po.User">
        SELECT * FROM USER WHERE USERNAME LIKE '%${value}%'
      </select>
    </mapper>
```
不要忘了把mapper.xml注册到SqlMapperConfig中
```xml
  <mappers>
    <mapper resource="mapper/UserMapper.xml"/>
  </mappers>
```

使用
```java
  try {
    String sqlMapConfig= "SqlMapConfig.xml";
    InputStream inputStream = Resources.getResourceAsStream(sqlMapConfig);
    sqlSessionFactory= new SqlSessionFactoryBuilder().build(inputStream);
  } catch (IOException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
  
  int id= 1;
		
  //获取sqlsession
  SqlSession sqlSession= sqlSessionFactory.openSession();
  //获取UserMapper的对象,生成代理对象
  UserMapper userMapper= sqlSession.getMapper(UserMapper.class);
  //调用方法
  User user;
  try {
    user = userMapper.findUserById(id);
    System.out.println(user.toString());
  } catch (Exception e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
  
```

问题总结
1. 如同上面的List，在mapper.xml设置的返回类型为User,实际为List,会根据返回类型选择selctOne
  或者selectList，但是如果返回的结果为一个集合，但是用来selectOne(也就是方法的返回值设成了User,mapper选择了selectOne区执行sql了，结果sql查询出来的却是一组对象)报错
2. mapper接口方法的参数只能有一个参数，是否会影响到系统开发。即使mapper的接口只有一个参数，但是我们可以使用封装的pojo对象，这样也可以使用多个参数（持久层的参数可以为包装类型map,pojo）,但是server层尽量不要使用包装类型（不利于扩展）
