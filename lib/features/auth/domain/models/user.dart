import 'package:equatable/equatable.dart';

enum UserRole {
  safetyOfficer(
    label: 'Safety Officer',
    code: 'SAFETY_OFFICER',
    description: 'Register labour, record attendance, conduct inspections and report hazards.',
  ),
  safetySupervisor(
    label: 'Safety Supervisor',
    code: 'SAFETY_SUPERVISOR',
    description: 'Monitor officers, review records and coordinate corrective actions.',
  ),
  safetyManager(
    label: 'Safety Manager',
    code: 'SAFETY_MANAGER',
    description: 'Manage safety operations, review reports and approve authorized actions.',
  ),
  projectInCharge(
    label: 'Project In-charge (PI)',
    code: 'PROJECT_IN_CHARGE',
    description: 'Handle authorized site exceptions, oversee escalations and coordinate departments.',
  ),
  siteEngineer(
    label: 'Site Engineer',
    code: 'SITE_ENGINEER',
    description: 'Resolve hazards and engineering-related safety actions assigned to the engineering team.',
  ),
  admin(
    label: 'Admin',
    code: 'ADMIN',
    description: 'Configure permissions, masters and site-level policies.',
  );

  final String label;
  final String code;
  final String description;

  const UserRole({
    required this.label,
    required this.code,
    required this.description,
  });

  static UserRole fromString(String roleStr) {
    return UserRole.values.firstWhere(
      (r) =>
          r.name.toLowerCase() == roleStr.toLowerCase() ||
          r.label.toLowerCase() == roleStr.toLowerCase() ||
          r.code.toLowerCase() == roleStr.toLowerCase(),
      orElse: () => UserRole.safetyOfficer,
    );
  }
}

class AuthUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String companyName;
  final List<String> permissions;
  final List<String> authorizedProjects;
  final Map<String, List<String>> authorizedSitesByProject;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.companyName = 'Sarjan Construction',
    this.permissions = const [],
    this.authorizedProjects = const [
      'Sarjan Sky Tower',
      'Metro Line Phase 4',
      'Riverfront Complex',
    ],
    this.authorizedSitesByProject = const {
      'Sarjan Sky Tower': [
        'Tower A - High Rise Zone',
        'Tower B - Foundation Zone',
        'Basement Excavation Bay',
      ],
      'Metro Line Phase 4': [
        'North Terminal Pier 12',
        'Underground Station Pier 4',
      ],
      'Riverfront Complex': [
        'Commercial Plaza Block 1',
        'Parking Deck Deck C',
      ],
    },
  });

  UserRole get roleType => UserRole.fromString(role);

  bool hasPermission(String permissionKey) {
    if (roleType == UserRole.admin) return true;
    return permissions.contains(permissionKey);
  }

  bool canAccessProject(String project) =>
      authorizedProjects.isEmpty || authorizedProjects.contains(project);

  List<String> sitesForProject(String project) {
    return authorizedSitesByProject[project] ?? const [];
  }

  AuthUser copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? companyName,
    List<String>? permissions,
    List<String>? authorizedProjects,
    Map<String, List<String>>? authorizedSitesByProject,
  }) {
    return AuthUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      companyName: companyName ?? this.companyName,
      permissions: permissions ?? this.permissions,
      authorizedProjects: authorizedProjects ?? this.authorizedProjects,
      authorizedSitesByProject:
          authorizedSitesByProject ?? this.authorizedSitesByProject,
    );
  }

  // Pre-configured role templates matching specifications
  static AuthUser forRole(UserRole userRole) {
    switch (userRole) {
      case UserRole.safetyOfficer:
        return const AuthUser(
          id: 'user_officer',
          name: 'Rajesh Patel',
          email: 'rajesh.safety@sarjan.com',
          role: 'Safety Officer',
          companyName: 'Sarjan Construction',
          permissions: [
            'register_labour',
            'mark_attendance',
            'scan_qr',
            'report_hazard',
            'report_incident',
            'start_inspection',
            'issue_ppe',
            'raise_emergency',
          ],
          authorizedProjects: [
            'Sarjan Sky Tower',
            'Metro Line Phase 4',
          ],
          authorizedSitesByProject: {
            'Sarjan Sky Tower': [
              'Tower A - High Rise Zone',
              'Tower B - Foundation Zone',
            ],
            'Metro Line Phase 4': [
              'Underground Station Pier 4',
            ],
          },
        );

      case UserRole.safetySupervisor:
        return const AuthUser(
          id: 'user_supervisor',
          name: 'Manoj Sharma',
          email: 'manoj.supervisor@sarjan.com',
          role: 'Safety Supervisor',
          companyName: 'Sarjan Construction',
          permissions: [
            'register_labour',
            'mark_attendance',
            'scan_qr',
            'report_hazard',
            'report_incident',
            'start_inspection',
            'issue_ppe',
            'create_task',
            'review_records',
            'coordinate_corrective_actions',
            'raise_emergency',
          ],
          authorizedProjects: [
            'Sarjan Sky Tower',
            'Metro Line Phase 4',
            'Riverfront Complex',
          ],
          authorizedSitesByProject: {
            'Sarjan Sky Tower': [
              'Tower A - High Rise Zone',
              'Tower B - Foundation Zone',
              'Basement Excavation Bay',
            ],
            'Metro Line Phase 4': [
              'North Terminal Pier 12',
              'Underground Station Pier 4',
            ],
            'Riverfront Complex': [
              'Commercial Plaza Block 1',
            ],
          },
        );

      case UserRole.safetyManager:
        return const AuthUser(
          id: 'user_manager',
          name: 'Dr. Vikram Joshi',
          email: 'vikram.manager@sarjan.com',
          role: 'Safety Manager',
          companyName: 'Sarjan Construction',
          permissions: [
            'register_labour',
            'mark_attendance',
            'scan_qr',
            'report_hazard',
            'report_incident',
            'start_inspection',
            'issue_ppe',
            'create_task',
            'request_material',
            'manage_operations',
            'review_reports',
            'approve_actions',
            'raise_emergency',
          ],
          authorizedProjects: [
            'Sarjan Sky Tower',
            'Metro Line Phase 4',
            'Riverfront Complex',
          ],
        );

      case UserRole.projectInCharge:
        return const AuthUser(
          id: 'user_pi',
          name: 'Anand Singhania',
          email: 'anand.pi@sarjan.com',
          role: 'Project In-charge (PI)',
          companyName: 'Sarjan Construction',
          permissions: [
            'handle_site_exceptions',
            'oversee_escalations',
            'coordinate_departments',
            'approve_actions',
            'raise_emergency',
            'report_incident',
          ],
          authorizedProjects: [
            'Sarjan Sky Tower',
            'Metro Line Phase 4',
            'Riverfront Complex',
          ],
        );

      case UserRole.siteEngineer:
        return const AuthUser(
          id: 'user_engineer',
          name: 'Kunal Dave',
          email: 'kunal.eng@sarjan.com',
          role: 'Site Engineer',
          companyName: 'Sarjan Construction',
          permissions: [
            'resolve_hazards',
            'engineering_safety_actions',
            'report_hazard',
            'request_material',
            'create_task',
            'raise_emergency',
          ],
          authorizedProjects: [
            'Sarjan Sky Tower',
          ],
          authorizedSitesByProject: {
            'Sarjan Sky Tower': [
              'Tower A - High Rise Zone',
              'Tower B - Foundation Zone',
            ],
          },
        );

      case UserRole.admin:
        return const AuthUser(
          id: 'user_admin',
          name: 'System Administrator',
          email: 'admin@sarjan.com',
          role: 'Admin',
          companyName: 'Sarjan Construction',
          permissions: [
            'register_labour',
            'mark_attendance',
            'scan_qr',
            'report_hazard',
            'report_incident',
            'start_inspection',
            'issue_ppe',
            'create_task',
            'request_material',
            'raise_emergency',
            'configure_permissions',
            'admin_full_access',
          ],
          authorizedProjects: [
            'Sarjan Sky Tower',
            'Metro Line Phase 4',
            'Riverfront Complex',
          ],
        );
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'companyName': companyName,
        'permissions': permissions,
        'authorizedProjects': authorizedProjects,
        'authorizedSitesByProject': authorizedSitesByProject,
      };

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String? ?? 'user_1',
        name: json['name'] as String? ?? 'Field Officer',
        email: json['email'] as String? ?? 'user@sarjan.com',
        role: json['role'] as String? ?? 'Safety Officer',
        companyName: json['companyName'] as String? ?? 'Sarjan Construction',
        permissions: (json['permissions'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        authorizedProjects: (json['authorizedProjects'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [
              'Sarjan Sky Tower',
              'Metro Line Phase 4',
              'Riverfront Complex',
            ],
        authorizedSitesByProject: (json['authorizedSitesByProject']
                as Map<String, dynamic>?)
            ?.map((k, v) => MapEntry(
                k, (v as List<dynamic>).map((e) => e.toString()).toList())) ??
            const {},
      );

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        companyName,
        permissions,
        authorizedProjects,
        authorizedSitesByProject,
      ];
}

