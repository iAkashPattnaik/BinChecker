/// The Async / Await Method Was Used To Create Promises
/// Bot Wont Fail Until Connection Error..
///
/// Async / Await Method Reduces Bugs...
///
/// Dart Is Based On The `C` Styled Programming
/// A OOP Language....
///
/// Easy And Productive Like `C`..
/// Also Fast.


// InBuilt
import 'dart:io' as io;
import 'dart:io' show Platform, exit;
import 'dart:convert';
import 'dart:core';

// Package
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:http/http.dart' as http;


// For Member Check
Future ChannelCheck(user_id) async {
  var ChannelId = Platform.environment['ChannelId'] ?? '-1001452834480';
  var token = Platform.environment['BotToken'] ?? '';
  var url = ('https://api.telegram.org/bot${token}/getChatMember?chat_id=${ChannelId}&user_id=${user_id})');
  var response = await http.get(url);
  if (response.body.toString().contains('administrator') || response.body.toString().contains('member') || response.body.toString().contains('creator')) {
    return 'ok';
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
    exit(69);
  }
  var bot = TeleDart(Telegram(token), Event());

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
          await message.reply('<b>Join My Channel To See My Source\n@IndianBots</b>', parse_mode: 'html');
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
            var url = 'https://bins-su-api.now.sh/api/';
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
          var bin = message.text;
          await message.reply('<b>Invalid Bin </b><code>${bin}</code>', parse_mode: 'html');
        }
      } else {
        await message.reply('<b>💘Join My Channel To Use Me\n@IndianBots</b>', parse_mode: 'html');
      }
  });

  bot
      .onMessage(entityType: '*')
      .listen((event) async {
        if (event.text == '/start' || event.text == '/source' || event.text == '/commands' || event.text.toString().startsWith('/bin')) {
          return false;
        } else if (event.text.toString().toLowerCase().contains('fuck')) {
          await event.reply('Jaa Na Lawde');
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
