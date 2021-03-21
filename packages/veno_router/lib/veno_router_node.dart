part of 'veno_router.dart';

class VenoRouterNode {
  VenoRouterNode({
    this.part,
    this.pattern,
    this.bindings,
    this.nodes,
  }) {
    nodes = nodes ?? [];
    bindings = bindings ?? {};
  }

  /// 路径部分
  ///
  final String part;

  /// 匹配模式
  ///
  String pattern;

  /// 绑定
  ///
  Map bindings;

  /// 子节点
  ///
  List<VenoRouterNode> nodes;

  /// 存在绑定
  ///
  bool get hasBinding => part.startsWith(':');

  /// 存在通配符
  ///
  bool get hasWildcard => part.startsWith('*');

  /// 绑定名
  ///
  String get bindingName => part.substring(1);

  ///
  ///
  VenoRouterNode _clone({
    String part,
    String pattern,
    Map bindings,
    List<VenoRouterNode> nodes,
  }) {
    return VenoRouterNode(
      part: part ?? this.part,
      pattern: pattern ?? this.pattern,
      bindings: bindings ?? this.bindings,
      nodes: nodes ?? this.nodes,
    );
  }

  /// 根据 [pattern] 匹配规则查询子节点
  ///
  VenoRouterNode find(String pattern, {
    List<String> parts,
    int depth,
    Map bindings,
    bool clone = true,
  }) {
    bindings = bindings ?? {};

    if (parts == null) {
      return find(pattern, parts: _patternToParts(pattern), depth: 0);
    } else if (parts.length == depth) {
      if (clone) {
        return _clone(bindings: bindings);
      }
      return this;
    } else {
      return nodes.firstWhere((node) {
        String part = parts[depth];

        // 值相等
        if (node.part == part) {
          return true;
        }

        // 存在通配符
        if (node.hasWildcard) {
          return true;
        }

        // 存在绑定
        if (node.hasBinding) {
          bindings[node.bindingName] = part;
          return true;
        }
        return false;
      }, orElse: () => null)?.find(
        pattern,
        parts: parts,
        depth: depth + 1,
        bindings: bindings,
        clone: clone,
      );
    }
  }

  /// 根据 [pattern] 匹配规则添加子节点
  ///
  ///   abc
  ///   /abc
  ///   /a/b/c
  ///
  void add(String pattern, {List<String> parts, int depth}) {
    if (parts == null) {
      add(pattern, parts: _patternToParts(pattern), depth: 0);
    } else if (parts.length == depth) {
      this.pattern = pattern;
    } else {
      final String part = parts[depth];
      VenoRouterNode node = find(part, parts: [part], depth: 0, clone: false);
      if (node == null) {
        node = VenoRouterNode(
          part: part,
          bindings: {}..addAll(bindings)..addAll(
              part.startsWith(':') ? {part.substring(1): null} : {}),
        );
        nodes.add(node);
      }
      node.add(pattern, parts: parts, depth: depth + 1);
    }
  }

  Map toMap() {
    return {
      'part': part,
      'pattern': pattern,
      'bindings': bindings,
      'nodes': nodes.map((node) => node.toMap()).toList(),
    };
  }
}
