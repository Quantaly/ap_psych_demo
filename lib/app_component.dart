import 'package:angular/angular.dart';
import 'package:angular_bloc/angular_bloc.dart';

import 'src/blocs/demo_bloc.dart';
import 'src/log_download.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'apsy-app',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.css'],
  pipes: [BlocPipe],
)
class AppComponent {
  final demoBloc = DemoBloc(downloadLog);
}
