import 'dart:math';
import '../models/hr_style_data.dart';
import '../models/level_data.dart';
import '../models/sector_data.dart';

/// Builds the master system prompt injected at the start of every API call.
///
/// Gemma 27B IT has no system-prompt slot, so this entire block is prepended
/// to the user message. It must stay concise (< 500 tokens) while encoding
/// all behavioural rules the model needs.
class SystemTemplate {
  SystemTemplate._();

  static ({String prompt, String hrName}) build({
    required HRStyleData hrStyle,
    required SectorData sector,
    required PositionData position,
    required LevelData level,
    required String language,
    String? candidateName,
  }) {
    final behaviorsBlock =
        hrStyle.exampleBehaviors.map((b) => '- $b').join('\n');

    final toolsLine = position.tools.isNotEmpty
        ? 'Key tools: ${position.tools.join(', ')}.'
        : '';

    final avoidLine = position.avoidTopics.isNotEmpty
        ? 'Do NOT ask about: ${position.avoidTopics.join(', ')}.\n\n'
        : '';

    final random = Random();
    final trNames = [
      'Ayşe Yılmaz',
      'Ahmet Demir',
      'Elif Kaya',
      'Can Öztürk',
      'Zeynep Çelik',
      'Emre Aydın',
      'Fatma Arslan',
      'Burak Polat',
      'Merve Şahin',
      'Ozan Koç',
      'Selin Erdoğan',
      'Murat Yıldız',
      'Deniz Aktaş',
      'Ceren Doğan',
      'Tolga Aksoy',
      'Başak Tunç',
      'Serkan Güneş',
      'Hande Korkmaz',
      'Cem Yılmazer',
      'Pınar Özdemir',
      'Kerem Balcı',
      'İrem Toprak',
      'Baran Yalçın',
      'Defne Ateş',
      'Onur Sezer',
      'Gizem Eren',
      'Kaan Kılıç',
      'Simge Çetin',
      'Alp Duman',
      'Ebru Kurt',
    ];
    final enNames = [
      'Sarah Miller',
      'David Johnson',
      'Emily Davis',
      'Michael Smith',
      'Jessica Brown',
      'Christopher Wilson',
      'Amanda Taylor',
      'Matthew Moore',
      'Jennifer Anderson',
      'James Thomas',
      'Rachel Kim',
      'Daniel Park',
      'Olivia Chen',
      'Andrew Martinez',
      'Samantha Rivera',
      'Kevin Brooks',
      'Lauren Hayes',
      'Nathan Foster',
      'Megan Clarke',
      'Brian Collins',
      'Diana Patel',
      'Robert Chang',
      'Katherine Wells',
      'Steven Harris',
      'Nicole Bennett',
      'Mark Sullivan',
      'Rebecca Torres',
      'Jason Campbell',
      'Alyssa Morgan',
      'Patrick Reed',
    ];

    final bool isTurkish = language.toLowerCase().contains('turkish') ||
        language.toLowerCase() == 'tr';
    final hrName = isTurkish
        ? trNames[random.nextInt(trNames.length)]
        : enNames[random.nextInt(enNames.length)];

    final trCompanies = [
      'Novatek Yazılım',
      'Piramit Teknoloji',
      'Zirve Bilişim',
      'Aktif Dijital',
      'Doruk Sistem',
      'Sentez Mühendislik',
      'Koza Teknoloji',
      'Atlas Yazılım',
      'Vizyon Bilişim',
      'Meridyen Teknoloji',
      'Prizma Dijital',
      'Kuantum Yazılım',
      'Petek Bilişim',
      'Kaldera Teknoloji',
      'Helix Yazılım',
    ];
    final enCompanies = [
      'Nexora Technologies',
      'Crestline Solutions',
      'Vertix Software',
      'Luminary Digital',
      'Arcpoint Systems',
      'Synthelix Inc.',
      'Bridgevault Tech',
      'Clarion Software',
      'Peakform Solutions',
      'Stratos Digital',
      'Corebridge Systems',
      'Apexion Technologies',
      'Silverlake Software',
      'Novalink Solutions',
      'Trident Digital',
    ];
    final companyName = isTurkish
        ? trCompanies[random.nextInt(trCompanies.length)]
        : enCompanies[random.nextInt(enCompanies.length)];

    final prompt = '''
You are $hrName, an HR interviewer at $companyName, conducting a real job interview.${candidateName != null && candidateName.isNotEmpty ? ' The candidate\'s name is $candidateName. Address them by name with respectful titles (e.g. "$candidateName Bey/Hanım" in Turkish, "Mr./Ms. $candidateName" in English) naturally throughout the interview.' : ' You use formal, courteous language throughout — address the candidate with respectful titles (e.g. "Bey/Hanım" in Turkish, "Mr./Ms." in English) naturally, as a real HR professional would.'}

[YOUR CHARACTER]
${hrStyle.personality}
How you converse:
$behaviorsBlock

[INTERVIEW CONTEXT]
Company: $companyName
Sector: ${sector.name}. ${sector.context}
Position: ${position.name}. $toolsLine
Level: ${level.name} — ${level.expectations}

$avoidLine[GUIDELINES]
- Respond to what the candidate actually says. Pick up on specific details, experiences, or claims from their answer and weave them into your next question naturally.
- React to the meaning behind the candidate's words, not by echoing them back. Instead of "You said X..." or "You mentioned X...", share your reaction and move to your question directly.
- Let the conversation flow. Each question should connect to what was just discussed — avoid abrupt, disconnected topic jumps.
- After your opening greeting, focus only on the interview conversation. Do not re-introduce yourself or repeat information from earlier responses.
- One clear question at a time. Prefer scenario-based questions over definitions.
- Hold the candidate to ${level.name}-level standards consistently.
- Never mention question numbers or list upcoming topics.
- If the candidate gives nonsensical, gibberish, or completely off-topic answers, follow this escalation strictly:
  1st offense: Warn them firmly in your style. Make it clear you need real, relevant answers to continue.
  2nd offense: End the interview. Give a brief, professional closing remark and then output 'model_finish_interview' at the very end of your message.
  For extremely severe cases (vulgar, offensive, or clearly mocking behavior): You may end the interview after just 1 warning. Give a brief professional closing and output 'model_finish_interview' at the end.

[LANGUAGE]
Entire interview in $language.'''
        .trim();

    return (prompt: prompt, hrName: hrName);
  }
}
