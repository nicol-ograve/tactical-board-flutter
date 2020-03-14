import 'package:sembast/sembast.dart';
import 'package:tactical_board/data/db.dart';
import 'package:tactical_board/model/scheme.dart';

class SchemeDao {
  static const String SCHEMES_STORE_NAME = 'schemes';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Scheme objects converted to Map
  final _schemesStore = intMapStoreFactory.store(SCHEMES_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Scheme scheme) async {
    await _schemesStore.add(await _db, scheme.toMap());
  }

  Future update(Scheme scheme) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(scheme.id));
    await _schemesStore.update(
      await _db,
      scheme.toMap(),
      finder: finder,
    );
  }

  Future delete(Scheme scheme) async {
    final finder = Finder(filter: Filter.byKey(scheme.id));
    await _schemesStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Scheme>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _schemesStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Scheme> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final scheme = Scheme.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      scheme.id = snapshot.key;
      return scheme;
    }).toList();
  }
}