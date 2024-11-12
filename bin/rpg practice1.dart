import 'dart:io';
import 'dart:math';

///캐릭터를 정의하기 위한 Character 클래스
class Character {
  String name;
  int hp;
  int attack;
  int defense;

  Character(this.name, this.hp, this.attack, this.defense);

  /// 공격 메서드 (`attackMonster(Monster monster)`)
  void attackMosnter(Monster monster) {
    int damage = attack - monster.defense;
    if (damage > 0) {
      monster.hp -= damage;
      print('${name}가 ${monster.name}에게 $damage를 주었습니다.');
    } else {
      print('${name}가 ${monster.name}에게 피해를 못줍니다.');
    }
  }

  ///방어 메서드 (`defend()`)
  void defenseMosnter(Monster monster) {
    int damage = monster.maxAttack - defense;
    if (damage > 0) {
      hp += damage;
      print('$name가 방어 태세를 취하여 $damage만큼 체력을 얻었습니다.');
    } else {
      print('$damage가 없어 변화가 없습니다.');
    }
  }

  void showStatus() {
    print('$name- 체력:$hp, 공격력:$attack, 방어력:$defense');
  }
}
//*     - 이름 (`String`)
//*     - 체력 (`int`)
//*     - 공격력 (`int`)
//*    - 방어력 (`int`)
//* - **메서드(Method)**
//*     - 공격 메서드 (`attackMonster(Monster monster)`)
//*         - 몬스터에게 공격을 가하여 피해를 입힙니다.
//*     - 방어 메서드 (`defend()`)
//*         - 방어 시 특정 행동을 수행합니다.
//*         예) 대결 상대인 몬스터가 입힌 데미지만큼 캐릭터의 체력을 상승시킵니다.
//*     - 상태를 출력하는 메서드 (`showStatus()`)
//*         - 캐릭터의 현재 체력, 공격력, 방어력을 매 턴마다 출력합니다.

///몬스터를 정의하기 위한 Monster 클래스
class Monster {
  String name;
  int hp;
  int maxAttack;
  int defense;
  Monster(this.name, this.hp, this.maxAttack, this.defense);

  void attackCharacter(Character character) {
    final random = Random();
    final monsterAttack = random.nextInt(maxAttack - 5) + 5;
    int damage = monsterAttack - character.defense;
    if (damage > 0) {
      hp -= damage;
      print('$name이 ${character.name}을 공격하여 $damage의 데미지를 입혔습니다.');
    } else {
      print('피해를 입히지 못했습니다.');
    }
  }

  void showStatus() {
    print('$name- 체력:$hp, 공격력:$maxAttack, 방어력:$defense');
  }
}
//*   - 이름 (`String`)
//* - 체력 (`int`)
//* - 랜덤으로 지정할 공격력 범위 최대값 (`int`)
//* → 몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없습니다. 랜덤으로 지정하여 캐릭터의 방어력과 랜덤 값 중 최대값으로 설정해주세요.
//* - 방어력(`int`) = 0
//* → 몬스터의 방어력은 0이라고 가정합니다.
// - **메서드(Method)**
//*     - 공격 메서드 (`attackCharacter(Character character)`)
//*         - 캐릭터에게 공격을 가하여 피해를 입힙니다.
//*         - 캐릭터에게 입히는 데미지는 몬스터의 공격력에서 캐릭터의 방어력을 뺀 값이며, 최소 데미지는 0 이상입니다.
//*     - 상태를 출력하는 메서드 (`showStatus()`)
//*         - 몬스터의 현재 체력과 공격력을 매 턴마다 출력합니다.

///게임을 정의하기 위한 Game 클래스
class Game {
  Character character;
  List<Monster> monsters;
  int defeatedCount = 0;
  Game(this.character, this.monsters);

  void startGame() {
    print('게임을 시작합니다!');
    character.showStatus();
    // 남아있는 몬스터의 개수만큼 반복하는 반복문(for)
    while (monsters.isNotEmpty && character.hp > 0) {
      battle();
    }
    if (character.hp <= 0) {
      saveGameResult('패배');
    } else if (monsters.isEmpty) {
      saveGameResult('승리');
    }
  }

  ///  - 전투를 진행하는 메서드 (`battle()`)
  void battle() {
    print('새로운 몬스터가 나타났습니다!');
    Monster monster = getRandomMonster();
    monster.showStatus();
    while (monster.hp > 0) {
      print('$character.name');
      print('행동을 선택하세요.(1:공격, 2:방어):');
      String? inputAction = stdin.readLineSync() ?? "";
      if (inputAction == '1') {
        character.attackMosnter(monster);
      } else if (inputAction == '2') {
        character.defenseMosnter(monster);
      } else {
        print('1과 2중 다시 입력해주세요.');
        continue;
      }
      print('${monster.name}의 턴');
      monster.attackCharacter(character);
      character.showStatus();
      monster.showStatus();
//         - 게임 중에 사용자는 매 턴마다 **행동을 선택**할 수 있습니다.
//         예) 공격하기(1), 방어하기(2)
//         - 매 턴마다 몬스터는 사용자에게 공격만 가합니다.
//         - 캐릭터는 몬스터 리스트에 있는 몬스터들 중 랜덤으로 뽑혀서 **대결을** 합니다.
//         - 처치한 몬스터는 몬스터 리스트에서 삭제되어야 합니다.
//         - 캐릭터의 체력은 대결 **간에 누적**됩니다.
    }
    if (monster.hp <= 0 && character.hp > 0) {
      monsters.remove(monster);
      defeatedCount++;
      print('${character.name}을 물리쳤습니다.');
      while (monsters.isNotEmpty) {
        print('다음 몬스터와 싸우시겠습니까?(y/n)');
        String? inputContinue = stdin.readLineSync() ?? "";
        if (inputContinue == 'n') {
          print('저장되었습니다.');
          saveGameResult('진행 중 종료');
        } else {
          return;
        }
      }
    } else {
      saveGameResult('무승부');
    }
  }

  Monster getRandomMonster() {
    final random = Random();
    final randomIndex = random.nextInt(monsters.length);
    return monsters[randomIndex];
  }

  void saveGameResult(String gameResult) {
    print('결과: $gameResult');
    print('저장하시겠습니까?(y/n)');
    String? inputSave = stdin.readLineSync() ?? "";
    if (inputSave == 'n') {
      print('저장하지 않고 게임을 종료하겠습니다.');
      exit(0);
    } else {
      print(
          '캐릭터이름: ${character.name}, 남은체력:${character.hp}, 게임결과:$gameResult 저장되었습니다.');
      String content =
          '캐릭터이름: ${character.name}, 남은체력:${character.hp}, 게임결과:$gameResult';
      File file = File('result.txt');
      file.writeAsStringSync(content);
      exit(0);
    }
  }
//* - **속성(Property)**
//*     - 캐릭터 (`Character`)
//*     - 몬스터 리스트 (`List<Monster>`)
//*     - 물리친 몬스터 개수(`int`)
//         - 몬스터 리스트의 개수보다 클 수 없습니다.
// - **메서드(Method)**
//     - 게임을 시작하는 메서드 (`startGame()`)
//         - 캐릭터의 체력이 0 이하가 되면 **게임이 종료**됩니다.
//         - 몬스터를 물리칠 때마다 다음 몬스터와 대결할 건지 선택할 수 있습니다.
//         예) “다음 몬스터와 대결하시겠습니까? (y/n)”
//         - 설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 **승리**합니다.
//     - 전투를 진행하는 메서드 (`battle()`)
//         - 게임 중에 사용자는 매 턴마다 **행동을 선택**할 수 있습니다.
//         예) 공격하기(1), 방어하기(2)
//         - 매 턴마다 몬스터는 사용자에게 공격만 가합니다.
//         - 캐릭터는 몬스터 리스트에 있는 몬스터들 중 랜덤으로 뽑혀서 **대결을** 합니다.
//         - 처치한 몬스터는 몬스터 리스트에서 삭제되어야 합니다.
//         - 캐릭터의 체력은 대결 **간에 누적**됩니다.
//     - 랜덤으로 몬스터를 불러오는 메서드(`getRandomMonster()`)
//         - `Random()` 을 사용하여 몬스터 리스트에서 랜덤으로 몬스터를 반환하여 대결합니다.
}

void main() async {
  File characterFile = File('character.txt');
  var charactertext = await characterFile.readAsString();
  List<String> cols = charactertext.split(',');
  String hp = cols[0];
  String attack = cols[1];
  String defense = cols[2];
  String name = '';
  Character character =
      Character(name, int.parse(hp), int.parse(attack), int.parse(defense));
  print('캐릭터의 이름을 입력해주세요.');

  while (true) {
    name = stdin.readLineSync() ?? "";
    if (RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
      break;
    } else {
      print('한글과 영어로만 다시 입력해주세요.');
    }
  }

  File monsterFile = File('monster.txt');
  var monstertext = await monsterFile.readAsString();
  List<String> rows = monstertext.split('\n');
  List<Monster> monsterList = [];
  for (final row in rows) {
    List<String> cols = row.split(',');
    String monsterName = cols[0];
    String hp = cols[1];
    String maxAttack = cols[2];
    String defense = cols[3];

    Monster monster = Monster(
        monsterName, int.parse(hp), int.parse(maxAttack), int.parse(defense));
    monsterList.add(monster);
  }

  Game game = Game(character, monsterList);
  game.startGame();
}
