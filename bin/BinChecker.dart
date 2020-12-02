/// The Async / Await Method Was Used To Create Promises
/// Bot Wont Fail Until Connection Error or Serer Error..
///
/// Async / Await Method Reduces Bugs...
///
/// Dart Is Based On The `C` Styled Programming
/// A OOP Language....
///
/// Easy And Productive Like `C`..
/// Also Fast. But Interpreted !
///
/// Star The Repo If You Like The Project.
///
///
///
/// Name - BinChecker
/// License - GPL-3.0-only
/// Creator - t.me/AKASH_AM1
/// Initial Release - 02-12-2020

// TODO - Add Database For Public Users Also.


// InBuilt
import 'dart:io' as io;
import 'dart:io' show Platform;
import 'dart:convert' show json;
import 'dart:core';

// Package
import 'package:teledart/teledart.dart' show TeleDart, Event;
import 'package:teledart/telegram.dart' show Telegram;
import 'package:http/http.dart' as http;


// For Member Check
Future ChannelCheck(user_id) async {
  var ChannelId = Platform.environment['ChannelId'] ?? '-1001452834480';
  var token = Platform.environment['BotToken'] ?? '';
  var url = ('https://api.telegram.org/bot${token}/getChatMember?chat_id=${ChannelId}&user_id=${user_id})');
  var response = await http.get(url);
  if (response.body.toString().contains('administrator') || response.body.toString().contains('member') || response.body.toString().contains('creator')) {
    return 'ok';
  } else if (response.body.toString().contains('AKASH_AM1')) {
    return 'Sar';
  } else if (response.body.toString().contains('ninjanaveen')) {
    return 'The PHP Guy';
  } else if (response.body.toString().contains('pureindialover')) {
    return 'The Getest Guy';
  } else if (response.body.toString().contains('Luciferr_XD')) {
    return 'Not Even A Guy';
  } else {
    return false;
  }
}


// Void Main Function
void main() {
  var token = Platform.environment['BotToken'] ?? '';
  print('Starting Bot With Token - "${token}"');
  if (token == '') {
    print('No BotToken Specified...');
  }
  var bot = TeleDart(
      Telegram(token),
      Event()
  );

  bot.start().then((me) async {
    print('@${me.username} Is Initialised');
  });


  bot
      .onCommand('start')
      .listen((message) async {
    var list = ['./bin/welcome_photo.webp', './bin/welcome_animation.tgs', './bin/welcome_photo2.webp'];
    var random = (list..shuffle()).first;
    if (random.endsWith('.webp')) {
      await message.replySticker(
          io.File(random)
      );
    } else if (random.endsWith('.tgs')) {
      await message.replyAnimation(
          io.File(random)
      );
    }
    await message.reply('<b>Hoi ${message.from.first_name},\nWelcome To IndianBots Bin Checker..'
        '\n\nAll My Commands Are Here - /commands</b>', parse_mode: 'html');
  });

  bot
      .onCommand('commands')
      .listen((message) async {
    await message.reply('<b>Commands\n'
        '\n'
        '/start - To Start The Bot\n'
        '/commands - To Display This Message\n'
        '/source - To Get The Link Of The Source\n'
        '/sysinfo - To Get Information About The System\n'
        '/bin xxxx - To Check The Bin\n'
        '\n'
        'Note -> Replace xxxx With The Bin You Want To Check.</b>', parse_mode: 'html');
  });

  bot
      .onCommand('source')
      .listen((message) async {
    var user_id = message.from.id;
    String req = await ChannelCheck(user_id);
    if (req.toString().contains('ok')) {
      await message.replyPhoto(
          io.File('./bin/logo.png'),
          caption: '<b>My Source Code Is On Github...\n'
              'https://github.com/IndianBots/BinChecker/\n'
              '\n'
              'Please Star The Repo For More Support.</b>',
          parse_mode: 'html'
      );
    } else {
      await message.reply('<b>Join My Channel To See My Source Code\n@IndianBots</b>', parse_mode: 'html');
    }
  });

  bot
      .onCommand('bin')
      .listen((message) async {
    var user_id = message.from.id;
    String req = await ChannelCheck(user_id);
    if (req.toString().contains('ok')) {
      try {
        var bin = message.text.split(' ')[1];
        if (bin != '' || bin.isNotEmpty) {
          final url = 'https://bins-su-api.now.sh/api/';
          var response = await http.get(url + bin);
          if (json.decode(response.body)['result']) {
            var data = json.decode(response.body)['data'];
            await message.reply('<b>'
                'Valid Bin\n'
                '\n'
                'Bin : ${data['bin']}\n'
                'Vendor : ${data['vendor']}\n'
                'Type : ${data['type']} Card\n'
                'Level : ${data['level']}\n'
                'Country : ${data['country']}\n'
                'Bank : ${data['bank']}\n'
                '\n'
                'Checker By : @IndianBots'
                '</b>', parse_mode: 'html');
          } else {
            await message.reply('<b>Invalid Bin</b>', parse_mode: 'html');
          }
        } else {
          await message.reply('<b>Invalid Bin </b><code>${bin}</code>', parse_mode: 'html');
        }
      } catch (error) {
        var bin = message.text.toString().replaceFirst('/ban', '');
        await message.reply('<b>Invalid Bin </b><code>${bin}</code>', parse_mode: 'html');
      }
    } else {
      await message.reply('<b>💘Join My Channel To Use Me\n@IndianBots</b>', parse_mode: 'html');
    }
  });

  bot
      .onCommand('sysinfo')
      .listen((message) async {
    var user_id = message.from.id;
    String req = await ChannelCheck(user_id);
    if (req.toString().contains('ok')) {
      await message.reply(
          '<b>Dart BinChecker Bot System Information\n\n'
          'Database : PostgreSQL 12.4\n'
          'Operating System : ${io.Platform.operatingSystem}\n'
          'Number Of Processors : ${io.Platform.numberOfProcessors}\n'
          'Dart SDK Link : <a href="https://storage.googleapis.com/dart-archive/channels/stable/release/2.10.4/sdk/dartsdk-linux-x64-release.zip">Click Here</a>\n'
          'Dart Version : 2.11.0-189.0.dev (dev)\n\n'
          'Deployed To : Heroku (For Now)</b>',
          parse_mode: 'html'
      );
    } else {
      await message.reply('<b>💘Join My Channel To Use Me\n@IndianBots</b>', parse_mode: 'html');
    }

  });

  bot
      .onMessage(entityType: '*')
      .listen((event) async {
    if (event.text == '/start' || event.text == '/source' || event.text == '/commands' || event.text.toString().startsWith('/bin') || event.text == '/sysinfo') {
      return false;
    } else if (event.text.toString().toLowerCase().contains('fuck')) {
      await event.reply('Jaa Na Lawde');
      return true;
    } else if (event.text.toString().toLowerCase().contains('maa chuda')) {
      await event.reply('Thik He,\nWese Teri Maa Ki Chut Ka Size Kya He?');
      return true;
    } else {
      await event.replySticker(
          io.File('./bin/spam.webp')
      );
      await event.reply(
          '<b>Please Don\'t Spam Here..</b>\n\nA Better Place To Spam Is '
              '<a href="https://t.me/${event.from.username ?? 'pureindialover'}">Here</a>',
          parse_mode: 'html',
          withQuote: false,
          disable_notification: false,
          disable_web_page_preview: false
      );
    }
  });
}
