import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String username;
  final String nama;
  final String noWA;
  final int lantai;
  final String noKamar;
  final int poinMember;
  final int totalOrder;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.username,
    required this.nama,
    required this.noWA,
    required this.lantai,
    required this.noKamar,
    required this.poinMember,
    required this.totalOrder,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      nama: data['nama'] ?? '',
      noWA: data['noWA'] ?? '',
      lantai: data['lantai'] ?? 0,
      noKamar: data['noKamar'] ?? '',
      poinMember: data['poinMember'] ?? 0,
      totalOrder: data['totalOrder'] ?? 0,
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'nama': nama,
      'noWA': noWA,
      'lantai': lantai,
      'noKamar': noKamar,
      'poinMember': poinMember,
      'totalOrder': totalOrder,
      'createdAt': createdAt,
    };
  }
}
