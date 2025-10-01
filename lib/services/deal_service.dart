import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/deal_model.dart';
import '../core/constants/firestore_constants.dart';
import '../core/errors/exceptions.dart';

abstract class DealService {
  Stream<List<Deal>> getDealsStream();
  Future<List<Deal>> getDealsOnce();
  Future<Deal> createDeal(Deal deal);
  Future<Deal> updateDeal(Deal deal);
  Future<void> deleteDeal(String dealId);
}

class FirebaseDealService implements DealService {
  final FirebaseFirestore _firestore;
  final String _collection = FirestoreCollections.deals;

  FirebaseDealService([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Deal>> getDealsStream() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('title')
          .snapshots()
          .map((QuerySnapshot snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Deal.fromMap({...data, 'id': doc.id});
            }).toList();
          });
    } catch (e) {
      throw FirestoreException(
        message: 'Error streaming deals',
        code: 'STREAM_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Deal>> getDealsOnce() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('title')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Deal.fromMap({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw FirestoreException(
        message: 'Error fetching deals',
        code: 'FETCH_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<Deal> createDeal(Deal deal) async {
    try {
      final dealId = const Uuid().v4();
      final now = DateTime.now();

      final dealWithId = Deal.withAutoCloseDate(
        id: dealId,
        title: deal.title,
        value: deal.value,
        description: deal.description,
        status: deal.status,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection(_collection)
          .doc(dealId)
          .set(dealWithId.toMap());

      return dealWithId;
    } catch (e) {
      throw FirestoreException(
        message: 'Error creating deal',
        code: 'CREATE_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<Deal> updateDeal(Deal deal) async {
    try {
      if (deal.id.isEmpty) {
        throw ValidationException.requiredField('deal.id');
      }

      final currentDoc = await _firestore
          .collection(_collection)
          .doc(deal.id)
          .get();

      Deal updatedDeal = deal;

      if (currentDoc.exists) {
        final currentDeal = Deal.fromMap(currentDoc.data()!);
        if (currentDeal.status != deal.status) {
          updatedDeal = deal.updateWithAutoCloseDate(deal.status);
        }
        updatedDeal = updatedDeal.copyWith(createdAt: currentDeal.createdAt);
      }

      updatedDeal = updatedDeal.copyWith(updatedAt: DateTime.now());

      final dealData = updatedDeal.toMap();
      dealData.remove('id');

      await _firestore.collection(_collection).doc(deal.id).update(dealData);

      return updatedDeal;
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Error updating deal',
        code: 'UPDATE_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteDeal(String dealId) async {
    try {
      if (dealId.isEmpty) {
        throw ValidationException.requiredField('dealId');
      }

      await _firestore.collection(_collection).doc(dealId).delete();
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Error deleting deal',
        code: 'DELETE_ERROR',
        originalError: e,
      );
    }
  }
}

