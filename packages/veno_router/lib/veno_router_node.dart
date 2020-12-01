part of 'veno_router.dart';

class VenoRouterNode {
  final String part;
  final bool isSpecial;
  List<VenoRouterNode> nodes;
  String pattern;
  Map value;

  VenoRouterNode({this.part, this.nodes, this.isSpecial, this.pattern}) {
    nodes = nodes ?? [];
  }

  /// 根据 [pattern] 匹配规则创建节点
  ///
  factory VenoRouterNode.pattern(String pattern) {
    VenoRouterNode node = VenoRouterNode()..add(pattern);
    return node;
  }

  /// 根据 [pattern] 匹配规则查询子节点
  ///
  VenoRouterNode find(String pattern, {List<String> parts, int depth}) {
    if (parts == null) {
      return find(pattern, parts: _patternToParts(pattern), depth: 0);
    } else if (parts.length == depth) {
      if (this.pattern?.isEmpty ?? true) {
        return null;
      }
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
}