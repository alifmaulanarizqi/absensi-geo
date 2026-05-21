import 'package:equatable/equatable.dart';

abstract class AddLocationEvent extends Equatable {
  const AddLocationEvent();

  @override
  List<Object?> get props => [];
}

class AddLocationNameChanged extends AddLocationEvent {
  const AddLocationNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class AddLocationCurrentLocationRequested extends AddLocationEvent {
  const AddLocationCurrentLocationRequested();
}

class AddLocationSubmitted extends AddLocationEvent {
  const AddLocationSubmitted();
}
