import 'package:flutter/material.dart';

String userName = "";
String userEmail = "";
bool asGuest = false;
bool refresh = true;

Color mainColor = Color(0xFF10217D);
List<String> symptomTitles = [
  'experiences-symptoms',
  'has-chronic-illnesses',
  'chronic-illnesses',
  'under-treatment-for-illness',
  'medication-for-illness',
  'duration-of-medication',
  'dosage-and-frequency-of-medication',
  'has-food-or-medication-allergies',
  'food-or-medication-allergies',
  'had-allergic-reactions-recently',
  'on-medication-recently',
  'medication-taken-recently',
  'dosage-and-frequency-administered',
  'any-additional-input',
];

Map<String,String> symptomTitlesMapping = {
  'experiences-symptoms': "Experiences symptoms",
  'has-chronic-illnesses': "Has chronic illnesses",
  'chronic-illnesses': "Chronic illnesses",
  'under-treatment-for-illness': "Under treatment for illnesses",
  'medication-for-illness': "Medication for illnesses",
  'duration-of-medication': "Duration of medication",
  'dosage-and-frequency-of-medication': "Dosage and frequency of medication",
  'has-food-or-medication-allergies': "Has food or medication allergies",
  'food-or-medication-allergies': "Food or medication allergies",
  'had-allergic-reactions-recently': "Had allergic reactions recently",
  'on-medication-recently': "On medication recently",
  'medication-taken-recently': "Medication taken recently",
  'dosage-and-frequency-administered': "Dosage and frequency administered for recent medication",
  'any-additional-input': "Any additional input",
};