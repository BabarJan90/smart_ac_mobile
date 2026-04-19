import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class Reset extends Equatable {
  final String message;

  const Reset({required this.message});

  @override
  List<Object?> get props => [message];
}
