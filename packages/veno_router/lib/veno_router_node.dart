part of 'veno_router.dart';

class VenoRouterNode {
  VenoRouterNode({
    this.part,
    this.nodes,
    this.isSpecial,
    this.pattern,
  }) {
    nodes = nodes ?? [];
  }

  /// 路径部分
  ///
  final String part;

  /// 子节点
  ///
  List<VenoRouterNode> nodes;

  /// 匹配模式
  ///
  String pattern;

  /// 是否特殊
  ///
  final bool isSpecial;

  /// 特殊值
  ///
  Map value;

  /// 根据 [pattern] 匹配规则查询子节点
  ///
  VenoRouterNode find(String pattern, {List<String> parts, int depth}) {
    if (parts == null) {
      return find(pattern, parts: _patternToParts(pattern), depth: 0);
    } else if (parts.length == depth) {
      if (isSpecial ?? false) {
        if (part.startsWith(':')) {
          value = {
            part.substring(1): parts.length > 1 ? parts[depth - 1] : null
          };
        }
      }
      return this;
    } else {
      return nodes.firstWhere((node) {
        return node.part == parts[depth] || node.isSpecial;
      }, orElse: () => null)?.find(pattern, parts: parts, depth: depth + 1);
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
      VenoRouterNode node = find(part, parts: [part], depth: 0);
      if (node == null) {
        node = VenoRouterNode(
          part: part,
          isSpecial: part.startsWith(':') || part.startsWith('*'),
        );
        nodes.add(node);
      }
      node.add(pattern, parts: parts, depth: depth + 1);
    }
  }

  Map toMap() {
    return {
      'part': part,
      'nodes': nodes.map((node) => node.toMap()).toList(),
      'pattern': pattern,
      'isSpecial': isSpecial,
      'value': value,
    };
  }
}
