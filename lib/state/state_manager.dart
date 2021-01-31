import 'package:flutter_filmapp/module/film.dart';
import 'package:flutter_filmapp/module/scenes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filmSelected=StateProvider((ref)=>Film());
final sceneSelected=StateProvider((ref)=>Scenes());
final isSearch=StateProvider((ref)=>false);
