//start game(battle, loadCharacter, loadMonster)
//battle
//

import 'dart:io';
import 'dart:math';

class Character {
  String name;
  int hp;
  int attack;
  int defense;

  Character(this.name, this.hp, this.attack, this.defense);

  /// 공격 메서드 (attackMonster(Monster monster))
  void attackMonster(Monster monster) {
    int damage = max(0, attack - monster.defense);
    monster.hp -= damage;
    print('$name이(가) ${monster.name}에게 $damage를 입혔습니다.');
  }

  /// 방어 메서드 (defend())
  void defenseMonster(Monster monster) {
    int damage = max(0, attack - monster.defense);
    monster.hp -= damage;
  }

  /// 상태를 출력하는 메서드 (showStatus())
  void showStatus() {
    print('$name-체력:$hp, 공격력:$attack, 방어력:$defense');
  }
}

class Monster {
  String name;
  int hp;
  int attack;
  int defense;

  Monster(this.name, this.hp, this.attack, this.defense);

  ///공격 매서드(attackCharacter(Character character))
  void attackCharacter(Character character) {
    int damage = max(0, attack - character.defense);
    character.hp -= damage;
    print('$name이(가) ${character.name}에게 $damage를 입혔습니다.');
  }

  /// 상태를 출력하는 메서드 (showStatus())
  void showStatus() {
    print('$name-체력:$hp, 공격력:$attack, 방어력:$defense');
  }
}

class Game {
  Character character;
  List<Monster> monsters = [];
  int killedMonster = 0;

  Game(this.character, this.killedMonster);

  void loadMonsterStats() {
    try {
      final file = File('monster.txt');
      final monsterText = file.readAsStringSync();
      List<String> rows = monsterText.split('\n');

      for (String row in rows) {
        final stats = row.split(',');
        if (stats.length != 3) {
          throw FormatException('Invalid monster data');
        }
        String name = stats[0];
        int hp = int.parse(stats[1]);
        int attack =
            max(character.defense, Random().nextInt(int.parse(stats[2]) + 1));
        int defense = 0;
        monsters.add(Monster(name, hp, attack, defense));
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는데 실패했습니다.$e');
      exit(1);
    }
  }

  void loadCharacterStats() {
    try {
      final file = File('character.txt');
      final characterText = file.readAsStringSync();
      final stats = characterText.split(',');
      if (stats.length != 3) {
        throw FormatException('Invalid monster data');
      }
      String name = getCharacterName();
      int hp = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);
      Character character = Character(name, hp, attack, defense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는데 실패했습니다.$e');
      exit(1);
    }
  }

  String getCharacterName() {
    print('캐릭터의 이름(영문또는 한글)을 입려해주세요.');
    while (true) {
      String? input = stdin.readLineSync();
      if (input != null &&
          input.isNotEmpty &&
          RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(input)) {
        return input;
      }
      print('잘못된 입력입니다. 한글또는 영문만 이용해주세요.');
    }
  }

  Monster getRandomMonster() {
    if (monsters.isEmpty) {
      throw StateError('몬스터 리스트가 비어있습니다.');
    }
    final random = Random();
    final randomIndex = random.nextInt(monsters.length);
    return monsters[randomIndex];
  }

  void saveGameResult(String gameResult) {
    print('결과: $gameResult');
    print('저장 하시겠습니까?(y,n)');
    String? inputSave = stdin.readLineSync() ?? 'y';
    if (inputSave.toLowerCase() == 'n') {
      print('저장하지 않고 게임을 종료하겠습니다.');
      exit(0);
    }

    File file = File('result.txt');
    file.writeAsStringSync(
        '캐릭터이름: ${character.name}, 남은체력:${character.hp}, 게임결과:$gameResult');
    print(
        '캐릭터이름: ${character.name}, 남은체력:${character.hp}, 게임결과:$gameResult 저장되었습니다. 게임을 종료합니다.');
    exit(0);
  }
}

void main() {}
