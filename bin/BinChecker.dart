/// The Async / Await Method Was Used To Create Promises
/// Bot Wont Fail Until Connection Error..
///
/// Async / Await Method Reduces Bugs...


// InBuilt
import 'dart:io' as io;
import 'dart:io' show Platform;
import 'dart:convert';
import 'dart:core';

// Package
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:http/http.dart' as http;


// For Member Check
Future ChannelCheck(user_id) async {
  var ChannelId = Platform.environment['ChannelId'];
  if (ChannelId = null) {
    ChannelId = '-1001452834480';
  }
  var url = ('https://api.telegram.org/bot${Platform.environment['BotToken']}/getChatMember?chat_id=${ChannelId}&user_id=${user_id})');
  var response = await http.get(url);
  if (response.body.toString().contains('administrator') || response.body.toString().contains('member') || response.body.toString().contains('creator')) {
    return 'ok';
  } else {
    return 'not_member';
  }
}

// Void Main Function
void main() {
  var token = Platform.environment['BotToken'];
  print('Starting Bot With Token - "${token}"');
  var bot = TeleDart(Telegram('1453283665:AAFcMD73SAYXclsFXs3HIbAKjmf9kCcmU78'), Event());

  bot.start().then((me) async {
    print('@${me.username} Is Initialised');
  });


  bot
      .onCommand('start')
      .listen((message) async {
        await message.replySticker(
          io.File('./welcome_photo.webp')
        );
        await message.reply('<b>Hoi ${message.from.first_name},\nWelcome To IndianBots Bin Checker..\n\nAll My Commands Are Here - /commands</b>', parse_mode: 'html');
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
      .listen((message) {
        var user_id = message.from.id;
        var req = ChannelCheck(user_id);
        if (req.toString() == 'ok') {
          message.replyPhoto(
              'https://raw.githubusercontent.com/DinoLeung/TeleDart/master/example/dash_paper_plane.png',
              caption: '<b>My Source Code Is On Github...\n'
                  'https://github.com/IndianBots/BinChecker/\n'
                  '\n'
                  'Please Star The Repo For More Support.</b>',
              parse_mode: 'html'
          );
        } else {
          message.reply('**Join My Channel To See My Source\n@IndianBots**', parse_mode: 'md');
        }
      });

  bot
      .onCommand('bin')
      .listen((message) async {
      var user_id = message.from.id;
      var req = ChannelCheck(user_id);
      if (req.toString() == 'ok') {
        try {
          var bin = message.text.split(' ')[1];
          if (bin != '' || bin.isNotEmpty) {
            var url = 'https://bins-su-api.now.sh/api/';
            var response = await http.get(url + bin);
            print('Response status: ${response.statusCode}');
            print('Body : ${response.body}');
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
        await message.reply('**Join My Channel To Use Me\n@IndianBots**', parse_mode: 'md');
      }
  });

  bot
      .onMessage(entityType: '*')
      .listen((event) {
        event.reply('Please Don\'t Spam Here..');
      });
}
