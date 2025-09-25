import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/deal_model.dart';

abstract class DealService {
  Future<List<Deal>> getDeals();
  Stream<List<Deal>> getDealsStream();
  Future<Deal> createDeal(Deal deal);
  Future<Deal> updateDeal(Deal deal);
  Future<void> deleteDeal(String dealId);
}

// Mock implementation for when Firebase is not available
class MockDealService implements DealService {
  final List<Deal> _deals = [
    Deal(
      id: '1',
      title: 'Website Redesign Project',
      value: 45000.0,
      description: 'Complete website redesign for Tech Solutions Inc.',
      status: DealStatus.negotiation,
      closeDate: DateTime.now().add(const Duration(days: 30)),
    ),
    Deal(
      id: '2',
      title: 'Marketing Campaign',
      value: 12000.0,
      description: 'Q4 digital marketing campaign for Digital Marketing Pro',
      status: DealStatus.proposal,
      closeDate: DateTime.now().add(const Duration(days: 15)),
    ),
    Deal(
      id: '3',
      title: 'Brand Identity Package',
      value: 8500.0,
      description: 'Complete brand identity design for Creative Designs LLC',
      status: DealStatus.qualified,
      closeDate: DateTime.now().add(const Duration(days: 45)),
    ),
    Deal(
      id: '4',
      title: 'Startup Hub Consultation',
      value: 15000.0,
      description: 'Business consultation services for Startup Hub',
      status: DealStatus.prospect,
      closeDate: null,
    ),
    Deal(
      id: '5',
      title: 'Innovation Labs Project',
      value: 75000.0,
      description: 'Custom development project for Innovation Labs',
      status: DealStatus.proposal,
      closeDate: DateTime.now().add(const Duration(days: 60)),
    ),
  ];

  @override
  Future<List<Deal>> getDeals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_deals);
  }

  @override
  Stream<List<Deal>> getDealsStream() {
    return Stream.periodic(const Duration(seconds: 1), (count) => List.from(_deals));
  }

  @override
  Future<Deal> createDeal(Deal deal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newDeal = Deal(
      id: const Uuid().v4(),
      title: deal.title,
      value: deal.value,
      description: deal.description,
      status: deal.status,
      closeDate: deal.closeDate,
    );
    _deals.add(newDeal);
    return newDeal;
  }

  @override
  Future<Deal> updateDeal(Deal deal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _deals.indexWhere((d) => d.id == deal.id);
    if (index != -1) {
      _deals[index] = deal;
      return deal;
    }
    throw Exception('Deal not found');
  }

  @override
  Future<void> deleteDeal(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _deals.removeWhere((deal) => deal.id == dealId);
  }
}

// Firebase implementation for production
class FirebaseDealService implements DealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'deals';

  @override
  Future<List<Deal>> getDeals() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('title')
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; 
        return Deal.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Error loading deals: $e');
    }
  }

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
              data['id'] = doc.id;
              return Deal.fromMap(data);
            }).toList();
          });
    } catch (e) {
      throw Exception('Error streaming deals: $e');
    }
  }

  @override
  Future<Deal> createDeal(Deal deal) async {
    try {
      final dealId = const Uuid().v4();

      // Create deal with automatic closeDate based on status
      final dealWithId = Deal.withAutoCloseDate(
        id: dealId,
        title: deal.title,
        value: deal.value,
        description: deal.description,
        status: deal.status,
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
      
      // Get the current deal to check if status changed
      final currentDoc = await _firestore
          .collection(_collection)
          .doc(deal.id)
          .get();
      
      Deal updatedDeal = deal;
      
      // If status changed, update closeDate automatically
      if (currentDoc.exists) {
        final currentDeal = Deal.fromMap(currentDoc.data()!);
        if (currentDeal.status != deal.status) {
          updatedDeal = deal.updateWithAutoCloseDate(deal.status);
        }
      }
      
      final dealData = updatedDeal.toMap();
      dealData.remove('id'); 
      
      await _firestore
          .collection(_collection)
          .doc(deal.id)
          .update(dealData);
      
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
      
      await _firestore
          .collection(_collection)
          .doc(dealId)
          .delete();
    } catch (e) {
      throw Exception('Error deleting deal: $e');
    }
  }
}
