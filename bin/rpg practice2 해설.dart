import 'dart:io';
import 'dart:math';

class Character {
  String name;
  int health;
  int attack;
  int defense;

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster) {
    int damage = max(0, attack - monster.defense);
    health -= damage;
    print('$name이(가) ${monster.name}에게 $damage를 입혔습니다.');
  }

  void defend(Monster monster) {
    int damage = max(0, attack - monster.defense);
    health += damage;
    print('$name이(가) 방어 태세를 취하여 $damage 만큼 체력을 얻었습니다.');
  }

  void showStatus() {
    print('$name - 체력:$health, 공격력:$attack, 방어력:$defense');
  }
}

class Monster {
  String name;
  int health;
  int attack;
  int defense = 0;

  Monster(this.name, this.health, this.attack);

  void attackCharacter(Character character) {
    int damage = max(0, attack - character.defense);
    health -= damage;
    print('$name이(가) ${character.name}에게 $damage를 입혔습니다.');
  }

  void showStatus() {
    print('$name - 체력:$health, 공격력:$attack, 방어력:$defense');
  }
}

class Game {
  Character character;
  List<Monster> monsters = [];
  int killedMonster = 0;

Game(this.character, this.monsters,this.killedMonster)
  Game() {
    loadMonsterStats();
    loadCharacterStats();
  }

  /// - 게임을 시작하는 메서드 (`startGame()`)
  void startGame() {
print('게임을 시작합니다!');
    character.showStatus();

    while (true) {
      Monster currentMonster = getRandomMonster();
      print('\n새로운 몬스터가 나타났습니다!');
      currentMonster.showStatus();

      battle(currentMonster);

      if (character.health <= 0) {
        print('게임 오버! ${character.name}이(가) 쓰러졌습니다.');
        saveResult(false);
        return;
      }

      if (killedMonster == 2) {
        print('\n축하합니다! 모든 몬스터를 물리쳤습니다.');
        saveResult(true);
        return;
      }

      print('\n다음 몬스터와 싸우시겠습니까? (y/n): ');
      String? response = stdin.readLineSync();

      if (response?.toLowerCase() != 'y') {
        print('게임을 종료합니다.');
        saveResult(true);
        return;
      }
    }
    //     - 캐릭터의 체력이 0 이하가 되면 **게임이 종료**됩니다.
    //     - 몬스터를 물리칠 때마다 다음 몬스터와 대결할 건지 선택할 수 있습니다.
    //     예) “다음 몬스터와 대결하시겠습니까? (y/n)”
    //     - 설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 **승리**합니다.
  }

  ///전투를 진행하는 메서드 (battle())
  void battle(Monster monster) {
        while (monster.health > 0 && character.health > 0) {
      print('\n${character.name}의 턴');
      stdout.write('행동을 선택하세요 (1: 공격, 2: 방어): ');
      String? action = stdin.readLineSync();
      if (action == '1') {
        character.attackMonster(monster);
      } else if (action == '2') {
        character.defend(monster.attack);
      } else {
        print('잘못된 입력입니다. 다시 선택해주세요.');
        continue;
      }

      if (monster.health <= 0) {
        print('${monster.name}을(를) 물리쳤습니다!');
        monsters.remove(monster);
        killedMonster++;
        break;
      }

      print('\n${monster.name}의 턴');

      monster.attackCharacter(character);

      character.showStatus();
      monster.showStatus();
    }
//     - 게임 중에 사용자는 매 턴마다 **행동을 선택**할 수 있습니다.
// 예) 공격하기(1), 방어하기(2)
// - 매 턴마다 몬스터는 사용자에게 공격만 가합니다.
// - 캐릭터는 몬스터 리스트에 있는 몬스터들 중 랜덤으로 뽑혀서 **대결을** 합니다.
// - 처치한 몬스터는 몬스터 리스트에서 삭제되어야 합니다.
// - 캐릭터의 체력은 대결 **간에 누적**됩니다.
  }

  ///랜덤으로 몬스터를 불러오는 메서드(getRandomMonster())
Monster getRandmonMonster() {
if(monsters.isEmpty){
  throw stateError('몬스터 리스트가 비어있습니다.');
}
return monsters[Random().nextInt(monsters.length)];
}
    

    // Random() 을 사용하여 몬스터 리스트에서 랜덤으로 몬스터를 반환하여 대결합니다.
  }

  ///몬스터의 정보를 불러오는 메서드
  void loadMonsterStats() {
    try{
      final file = File('monster.txt');
      final lines=file.readAsLinesSync();
      for(var line in lines){
        final stats= line.split(',');
        if(stats.length!=3) throw FormatException('Invalid monster data');

        String name=stats[0];
        int health=int.parse(stats[1]);
        int attack=max(character.defense,Random().nextInt(int.parse(stats[2])));

        monsters.add(Monster(name,health,attack));
      }
    }catch(e){
      print('몬스터 테이터를 블러오는데 실패했습니다.$e');
      exit(1);
    }
  }

  ///캐릭터의 정보를 불러오는 메서드
  void loadCharacterStats() {
        try{
      final file = File('character.txt');
      final contents=file.readAsStringSync();
      final stats=contents.split(',');
      if(stats.length!=3) throw FormatException('Invalid character data');

      int health=int.parse(stats[0]);
      int attack=int.parse(stats[1]);
      int defense=int.parse(stats[2]);

      String name=getCharacterName();
    Character character=Character(name,health,attack,defense);
    } catch(e){
      print('캐릭터 데이터를 불러오는데 실패했습니다. $e');
      exit(1);
    }
  }

  ///게임을 저장하는 메서드('승리', '무승부', '패배')
  void saveResult(bool victory) {
    print('결과를 저장히사겠습니까?(y/n)');
    String? response=stdin.readLineSync();
    if(response?.toLowercase()=='y'){
      try{
        final file=File('result.txt');
        final result=victory?'승리':'패배';
        file.writeAsStringSync('캐릭터 ${character.name}, 남은체력:${character.health},결과:'$result');
        print('결과가 저장되었습니다.');
      }catch(e){
      print('결과 저장에 실패했습니다.');}
    }
  }
      }

void main() {
  Game game = Game();
  game.startGame();
}
