package utils {
/**
 * LRU (Least Recently Used) 缓存器
 * 支持配置最大容量，当超过容量时自动移除最久未使用的缓存项
 */
public class LRUCache {


    // 实例属性
    private var _capacity:int;
    private var _size:int = 0;
    private var _cache:Object = {}; // 哈希表，存储key -> node的映射
    private var _head:CacheNode; // 虚拟头节点（最近使用的）
    private var _tail:CacheNode; // 虚拟尾节点（最久未使用的）

    /**
     * LRU缓存构造函数
     * @param capacity 缓存最大容量，默认为100
     */
    public function LRUCache(capacity:int = 100) {
        if (capacity <= 0) {
            throw new Error("缓存容量必须大于0");
        }

        _capacity = capacity;

        // 初始化虚拟头尾节点
        _head = new CacheNode();
        _tail = new CacheNode();
        _head.next = _tail;
        _tail.prev = _head;
    }

    /**
     * 获取缓存值
     * @param key 缓存键
     * @return 缓存值，如果不存在返回null
     */
    public function get(key:*):* {
        var keyStr:String = String(key);
        var node:CacheNode = _cache[keyStr];

        if (node != null) {
            // 将访问的节点移到头部（最近使用）
            moveToHead(node);
            return node.value;
        }

        return null;
    }

    /**
     * 设置缓存值
     * @param key 缓存键
     * @param value 缓存值
     */
    public function put(key:*, value:*):void {
        var keyStr:String = String(key);
        var node:CacheNode = _cache[keyStr];

        if (node != null) {
            // 更新现有节点的值
            node.value = value;
            moveToHead(node);
        } else {
            // 创建新节点
            var newNode:CacheNode = new CacheNode(key, value);

            if (_size >= _capacity) {
                // 缓存已满，移除最久未使用的节点
                var tail:CacheNode = removeTail();
                delete _cache[String(tail.key)];
                _size--;
            }

            // 添加新节点到头部
            _cache[keyStr] = newNode;
            addToHead(newNode);
            _size++;
        }
    }

    /**
     * 检查缓存中是否存在指定键
     * @param key 缓存键
     * @return 是否存在
     */
    public function has(key:*):Boolean {
        return _cache[String(key)] != null;
    }

    /**
     * 删除指定键的缓存
     * @param key 缓存键
     * @return 是否成功删除
     */
    public function remove(key:*):Boolean {
        var keyStr:String = String(key);
        var node:CacheNode = _cache[keyStr];

        if (node != null) {
            removeNode(node);
            delete _cache[keyStr];
            _size--;
            return true;
        }

        return false;
    }

    /**
     * 清空所有缓存
     */
    public function clear():void {
        _cache = {};
        _size = 0;
        _head.next = _tail;
        _tail.prev = _head;
    }

    /**
     * 获取当前缓存大小
     */
    public function get size():int {
        return _size;
    }

    /**
     * 获取缓存容量
     */
    public function get capacity():int {
        return _capacity;
    }

    /**
     * 设置缓存容量
     * @param newCapacity 新的容量值
     */
    public function set capacity(newCapacity:int):void {
        if (newCapacity <= 0) {
            throw new Error("缓存容量必须大于0");
        }

        _capacity = newCapacity;

        // 如果新容量小于当前大小，需要移除多余的缓存项
        while (_size > _capacity) {
            var tail:CacheNode = removeTail();
            delete _cache[String(tail.key)];
            _size--;
        }
    }

    /**
     * 检查缓存是否为空
     */
    public function get isEmpty():Boolean {
        return _size === 0;
    }

    /**
     * 检查缓存是否已满
     */
    public function get isFull():Boolean {
        return _size >= _capacity;
    }

    /**
     * 获取所有缓存键的数组
     */
    public function get keys():Array {
        var keysArray:Array = [];
        var current:CacheNode = _head.next;

        while (current !== _tail) {
            keysArray.push(current.key);
            current = current.next;
        }

        return keysArray;
    }

    /**
     * 获取所有缓存值的数组
     */
    public function get values():Array {
        var valuesArray:Array = [];
        var current:CacheNode = _head.next;

        while (current !== _tail) {
            valuesArray.push(current.value);
            current = current.next;
        }

        return valuesArray;
    }

    /**
     * 获取缓存使用率（0-1之间的浮点数）
     */
    public function get utilizationRate():Number {
        return _capacity > 0 ? Number(_size) / Number(_capacity) : 0;
    }

    /**
     * 获取最近使用的缓存项（不影响访问顺序）
     * @return 包含key和value的对象，如果缓存为空返回null
     */
    public function peekMostRecent():Object {
        if (_head.next !== _tail) {
            return {
                key: _head.next.key,
                value: _head.next.value
            };
        }
        return null;
    }

    /**
     * 获取最久未使用的缓存项（不影响访问顺序）
     * @return 包含key和value的对象，如果缓存为空返回null
     */
    public function peekLeastRecent():Object {
        if (_tail.prev !== _head) {
            return {
                key: _tail.prev.key,
                value: _tail.prev.value
            };
        }
        return null;
    }

    /**
     * 遍历缓存（从最近使用到最久未使用）
     * @param callback 回调函数，接收(key, value, index)参数
     */
    public function forEach(callback:Function):void {
        if (callback == null) {
            throw new Error("回调函数不能为null");
        }

        var current:CacheNode = _head.next;
        var index:int = 0;

        while (current !== _tail) {
            callback(current.key, current.value, index);
            current = current.next;
            index++;
        }
    }

    /**
     * 获取缓存统计信息
     */
    public function getStats():Object {
        return {
            size: _size,
            capacity: _capacity,
            utilizationRate: utilizationRate,
            isEmpty: isEmpty,
            isFull: isFull,
            mostRecent: peekMostRecent(),
            leastRecent: peekLeastRecent()
        };
    }

    // ==================== 私有方法 ====================

    /**
     * 将节点添加到头部
     */
    private function addToHead(node:CacheNode):void {
        node.prev = _head;
        node.next = _head.next;
        _head.next.prev = node;
        _head.next = node;
    }

    /**
     * 移除指定节点
     */
    private function removeNode(node:CacheNode):void {
        node.prev.next = node.next;
        node.next.prev = node.prev;
    }

    /**
     * 将节点移动到头部
     */
    private function moveToHead(node:CacheNode):void {
        removeNode(node);
        addToHead(node);
    }

    /**
     * 移除尾部节点（最久未使用的）
     */
    private function removeTail():CacheNode {
        var lastNode:CacheNode = _tail.prev;
        removeNode(lastNode);
        return lastNode;
    }

    /**
     * 转换为字符串表示
     */
    public function toString():String {
        var items:Array = [];
        var current:CacheNode = _head.next;

        while (current !== _tail) {
            items.push(String(current.key) + ":" + String(current.value));
            current = current.next;
        }

        return "[LRUCache size=" + _size + "/" + _capacity + " items={" + items.join(", ") + "}]";
    }
}
}
// 缓存节点类
class CacheNode {
    public var key:*;
    public var value:*;
    public var prev:CacheNode;
    public var next:CacheNode;

    public function CacheNode(key:* = null, value:* = null) {
        this.key = key;
        this.value = value;
        this.prev = null;
        this.next = null;
    }
}