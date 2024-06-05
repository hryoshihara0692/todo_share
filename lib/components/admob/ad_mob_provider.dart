import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_share/components/admob/ad_mob.dart';

final adMobProvider = ChangeNotifierProvider((ref) => AdMobNotifier());
