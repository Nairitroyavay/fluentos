import '../data/local/local_persistence_repository.dart';
import 'fake_fluentos_repository.dart';

class MockPersistenceRepository extends LocalPersistenceRepository {
  MockPersistenceRepository({
    required super.storage,
    required FakeFluentOSRepository defaults,
  }) : super(defaultUser: defaults.loadUser());
}
