import 'dart:io';
import 'dart:math';

class Character {
  String name;
  int hp;
  int attackStrength;
  int defenseStrength;

  Character(this.name, this.hp, this.attackStrength, this.defenseStrength);

  /// 공격 메서드 (attackMonster(Monster monster))
  void attackMonster(Monster monster) {
    int damage = attackStrength - monster.defenseStrength;
    if (damage >= 0) {
      monster.hp -= damage;
    }

    print('$name이 ${monster.name}을 공격하여 $damage의 데미지를 입혔습니다.');
  }

  /// 방어 메서드 (defend())
  void defenseMonseter(Monster monster) {
    int damage = monster.maxAttackStrength - defenseStrength;
    if (damage >= 0) {
      hp += damage;
      print('$name가 방어 태세를 취하여 $damage만큼 체력을 얻었습니다.');
    }
  }

  /// 상태를 출력하는 메서드 (showStatus())
  void showStatus() {
    //캐릭터 상태 반영 함수
    print('$name- 체력:$hp, 공격력:$attackStrength, 방어력:$defenseStrength');
  }
}

class Monster {
  String name;
  int hp;
  int maxAttackStrength;
  int defenseStrength;

  Monster(this.name, this.hp, this.maxAttackStrength, this.defenseStrength);

  /// 공격 메서드 (attackCharacter(Character character))
  void attackCharacter(Character character) {
    final random = Random();
    final randomMonsterAttack = random.nextInt(maxAttackStrength - 5) + 5;

    int damage = randomMonsterAttack - character.defenseStrength;
    if (damage >= 0) {
      character.hp -= damage;
      print('$name이 ${character.name}을 공격하여 $damage의 데미지를 입혔습니다.');
    }
  }

  /// 상태를 출력하는 메서드 (showStatus())
  void showStatus() {
    //몬스터 상태 확인함수
    print('$name- 체력:$hp, 공격력:$maxAttackStrength, 방어력:$defenseStrength');
  }
}

class Game {
  Character character;
  List<Monster> monsters; //몬스터 목록
  int defeatedCount = 0; // 몬스터 퇴치 회수
  Game(this.character, this.monsters);

  /// - 게임을 시작하는 메서드 (`startGame()`)
  void startGame() {
    print('게임을 시작합니다!');
    character.showStatus();
//남아있는 몬스터의 개수만큼 반복하는 반복문(for)
    while (monsters.isNotEmpty && character.hp > 0) {
      battle();
    }
    if (character.hp <= 0) {
      saveGameResult('패배');
    } else if (monsters.isEmpty) {
      saveGameResult('승리');
    }

    // - 캐릭터의 체력이 0 이하가 되면 **게임이 종료**됩니다.
    // - 몬스터를 물리칠 때마다 다음 몬스터와 대결할 건지 선택할 수 있습니다.
    // 예) “다음 몬스터와 대결하시겠습니까? (y/n)”
    // - 설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 **승리**합니다.
  }

  //몬스터의 체력이 0이 되거나 케릭터의 체력이 0이 될때까지 반복한는 반복문
  /// 전투를 진행하는 메서드 (battle())
  void battle() {
    print('새로운 몬스터가 나타났습니다!');
    Monster monster = getRandomMonster();
    monster.showStatus();
    while (monster.hp > 0 && character.hp > 0) {
      print('${character.name}의 턴');
      print('행동을 선택하세요.(1:공격, 2:방어):');
      String? inputContinue = stdin.readLineSync();
      if (inputContinue == '1') {
        character.attackMonster(monster);
      } else if (inputContinue == '2') {
        character.defenseMonseter(monster);
      } else {
        print('잘못된 값을 입력하였습니다.');
        continue;
      }
      print('${monster.name}의 턴');
      monster.attackCharacter(character);
      character.showStatus();
      monster.showStatus();

      //사용자의 턴 1번&몬스터의 턴 1번 반복
      //monsters에서 monster 하나 없애주기(monster의 체력이 0일때)
    }
    if (monster.hp <= 0 && character.hp > 0) {
      monsters.remove(monster);
      defeatedCount++;
      while (monsters.isNotEmpty) {
        print('다음 몬스터와 싸우시겠습니까?(y/n)');
        String? inputContinue = stdin.readLineSync() ?? "";
        if (inputContinue == "n") {
          saveGameResult('진행 중 종료');
        } else {
          return;
        }
      }
      return;
    } else {
      saveGameResult('무승부');
    }
//     - 게임 중에 사용자는 매 턴마다 **행동을 선택**할 수 있습니다.
// 예) 공격하기(1), 방어하기(2)
// - 매 턴마다 몬스터는 사용자에게 공격만 가합니다.
// - 캐릭터는 몬스터 리스트에 있는 몬스터들 중 랜덤으로 뽑혀서 **대결을** 합니다.
// - 처치한 몬스터는 몬스터 리스트에서 삭제되어야 합니다.
// - 캐릭터의 체력은 대결 **간에 누적**됩니다.
  }

  void saveGameResult(String gameResult) {
    print('결과: $gameResult');
    print('저장 하시겠습니까?(y,n)');
    String? inputSave = stdin.readLineSync() ?? "";
    if (inputSave == 'n') {
      print('저장하지 않고 게임을 종료하겠습니다.');
      exit(0);
    } else {
      String content =
          '캐릭터이름: ${character.name}, 남은체력:${character.hp}, 게임결과:$gameResult';

      File file = File('result.txt');
      file.writeAsStringSync(content);
      print(
          '캐릭터이름: ${character.name}, 남은체력:${character.hp}, 게임결과:$gameResult 저장되었습니다. 게임을 종료합니다.');
      exit(0);
    }
  }

  /// - 랜덤으로 몬스터를 불러오는 메서드(`getRandomMonster()`)
  Monster getRandomMonster() {
    final random = Random();
    final randomIndex = random.nextInt(monsters.length);
    return monsters[randomIndex];
    // - `Random()` 을 사용하여 몬스터 리스트에서 랜덤으로 몬스터를 반환하여 대결합니다.
  }
}

void main() async {
  File characterFile = File('character.txt'); //(파일경로 작성)
  var charactertext = await characterFile.readAsString();
  List<String> cols = charactertext.split(',');
  String hp = cols[0];
  String attackStrength = cols[1];
  String defenseStrength = cols[2];
  print('캐릭터의 이름을 입력하세요.:');
  String name = '';

  while (true) {
    name = stdin.readLineSync() ?? "";
    if (RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
      break;
    } else {
      print('한글과 영어로만 다시 입력해주세요.');
    }
  }
  Character character = Character(name, int.parse(hp),
      int.parse(attackStrength), int.parse(defenseStrength));

  File monsterFile = File('monster.txt'); //(파일경로 작성)
  var monstertext = await monsterFile.readAsString();
  List<String> rows = monstertext.split('\n');
  List<Monster> monsterList = [];
  for (final row in rows) {
    List<String> cols = row.split(',');
    String monsterName = cols[0];
    String hp = cols[1];
    String maxAttackStrength = cols[2];
    String defenseStrength = cols[3];

    Monster monster = Monster(monsterName, int.parse(hp),
        int.parse(maxAttackStrength), int.parse(defenseStrength));
    monsterList.add(monster);
  }
  Game game = Game(character, monsterList);
  game.startGame();
}
