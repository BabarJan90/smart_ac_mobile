import 'package:domain/domain.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetDbUseCase extends UseCase {
  final SmartACApiRepository _repository;

  ResetDbUseCase(this._repository);

  Future<Result<Reset>> call() async {
    return _repository.resetDb();
  }
}
