import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/deal_model.dart';

abstract class DealService {
  Stream<List<Deal>> getDealsStream();
  Future<List<Deal>> getDealsOnce();
  Future<Deal> createDeal(Deal deal);
  Future<Deal> updateDeal(Deal deal);
  Future<void> deleteDeal(String dealId);
}

class FirebaseDealService implements DealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'deals';

  @override
  Stream<List<Deal>> getDealsStream() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('title')
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
            return snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return Deal.fromMap(data);
            }).toList();
          });
    } catch (e) {
      throw Exception('Error streaming deals: $e');
    }
  }

  @override
  Future<List<Deal>> getDealsOnce() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('title')
          .get();

      return snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Deal.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching deals: $e');
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
      throw Exception('Error creating deal: $e');
    }
  }

  @override
  Future<Deal> updateDeal(Deal deal) async {
    try {
      if (deal.id.isEmpty) {
        throw Exception('Deal ID cannot be empty');
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
    } catch (e) {
      throw Exception('Error updating deal: $e');
    }
  }

  @override
  Future<void> deleteDeal(String dealId) async {
    try {
      if (dealId.isEmpty) {
        throw Exception('Deal ID cannot be empty');
      }

      await _firestore.collection(_collection).doc(dealId).delete();
    } catch (e) {
      throw Exception('Error deleting deal: $e');
    }
  }
}
