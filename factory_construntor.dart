void main() {
  final parent = Parent(id: 1);
  print(parent.id);

  final child = Child(id: 3);

  print(child.id);

  final parent2 = Parent.fromInt(5);
  print(parent2);
  print(parent2.id);

  final cat = Animal(name: 'cat', age: 3, sound: 'meow');
  print(cat.name);
  print(cat.age);
  print(cat.sound);

  final tiger = Animal(name: 'tiger', age: 5, sound: 'roar');
  print(tiger);
  print(tiger.name);
  print(tiger.age);
}

class Parent {
  final int id;

  // 일반적으로 이 Constructor를 실행을 하면 현재 클래스만 인스턴스화해서 반환해준다.
  // 그런데 Factory Constructor를 사용하게 되면 현재 클래스의 인스턴스뿐만 아니라
  // 현재 클래스를 상속하고 있는 클래스도 인스턴스화해서 반환할 수가 있다.
  // 💡 데이터 모델링 할 때 유용하게 쓸 수 있다.
  Parent({required this.id});

  // factory Parent.fromInt(int id) {
  //   return Parent(id: id);
  // }
  factory Parent.fromInt(int id) {
    return Child(id: id);
  }
}

class Child extends Parent {
  Child({required super.id});
}

// Factory Constructor

class Animal {
  final String name;
  final int age;
  final String sound;

  Animal({
    required this.name,
    required this.age,
    required this.sound,
  });
}
