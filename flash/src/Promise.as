package {
import flash.events.TimerEvent;
import flash.utils.Timer;

/**
 * Promise类 - 符合Promise/A+规范的ActionScript实现
 */
public class Promise {

    // Promise状态常量
    private static const PENDING:String = "pending";
    private static const FULFILLED:String = "fulfilled";
    private static const REJECTED:String = "rejected";

    // 实例属性
    private var _state:String = PENDING;
    private var _value:*;
    private var _reason:*;
    private var _fulfillmentHandlers:Array = [];
    private var _rejectionHandlers:Array = [];

    /**
     * Promise构造函数
     * @param executor 执行器函数，接收resolve和reject两个参数
     */
    public function Promise(executor:Function) {
        if (executor == null) {
            throw new Error("Promise constructor requires an executor function");
        }

        try {
            executor(resolve, reject);
        } catch (error:Error) {
            reject(error);
        }
    }

    /**
     * 获取当前Promise状态
     */
    public function get state():String {
        return _state;
    }

    /**
     * 获取Promise的值
     */
    public function get value():* {
        return _value;
    }

    /**
     * 获取Promise的拒绝原因
     */
    public function get reason():* {
        return _reason;
    }

    /**
     * then方法 - Promise链式调用的核心
     * @param onFulfilled 成功回调
     * @param onRejected 失败回调
     * @return 新的Promise实例
     */
    public function then(onFulfilled:Function = null, onRejected:Function = null):Promise {
        return new Promise(function (resolve:Function, reject:Function):void {

            function handleFulfilled():void {
                if (onFulfilled != null && typeof onFulfilled === "function") {
                    try {
                        var result:* = onFulfilled(_value);
                        resolvePromise(result, resolve, reject);
                    } catch (error:Error) {
                        reject(error);
                    }
                } else {
                    resolve(_value);
                }
            }

            function handleRejected():void {
                if (onRejected != null && typeof onRejected === "function") {
                    try {
                        var result:* = onRejected(_reason);
                        resolvePromise(result, resolve, reject);
                    } catch (error:Error) {
                        reject(error);
                    }
                } else {
                    reject(_reason);
                }
            }

            if (_state === FULFILLED) {
                // 异步执行
                scheduleCallback(handleFulfilled);
            } else if (_state === REJECTED) {
                // 异步执行
                scheduleCallback(handleRejected);
            } else {
                // 仍处于pending状态，添加到回调队列
                _fulfillmentHandlers.push(handleFulfilled);
                _rejectionHandlers.push(handleRejected);
            }
        });
    }

    /**
     * catch方法 - 捕获Promise拒绝
     * @param onRejected 拒绝回调
     * @return 新的Promise实例
     */
    public function catch0(onRejected:Function):Promise {
        return then(null, onRejected);
    }

    /**
     * finally方法 - 无论成功失败都会执行
     * @param onFinally 最终回调
     * @return 新的Promise实例
     */
    public function finally(onFinally:Function):Promise {
        return then(
                function (value:*):* {
                    return Promise.resolve(onFinally()).then(function ():* {
                        return value;
                    });
                },
                function (reason:*):* {
                    return Promise.resolve(onFinally()).then(function ():* {
                        throw reason;
                    });
                }
        );
    }

    /**
     * 内部resolve方法
     */
    private function resolve(value:*):void {
        if (_state !== PENDING) return;

        if (value === this) {
            reject(new Error("Promise cannot resolve to itself"));
            return;
        }

        if (value is Promise) {
            value.then(resolve, reject);
            return;
        }

        _state = FULFILLED;
        _value = value;

        // 执行所有成功回调
        for each (var handler:Function in _fulfillmentHandlers) {
            scheduleCallback(handler);
        }

        // 清空回调队列
        _fulfillmentHandlers = [];
        _rejectionHandlers = [];
    }

    /**
     * 内部reject方法
     */
    private function reject(reason:*):void {
        if (_state !== PENDING) return;

        _state = REJECTED;
        _reason = reason;

        // 执行所有失败回调
        for each (var handler:Function in _rejectionHandlers) {
            scheduleCallback(handler);
        }

        // 清空回调队列
        _fulfillmentHandlers = [];
        _rejectionHandlers = [];
    }

    /**
     * 解析Promise结果
     */
    private function resolvePromise(result:*, resolve:Function, reject:Function):void {
        if (result is Promise) {
            result.then(resolve, reject);
        } else {
            resolve(result);
        }
    }

    /**
     * 异步调度回调函数
     */
    private function scheduleCallback(callback:Function):void {
        var timer:Timer = new Timer(1, 1);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, function (event:TimerEvent):void {
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, arguments.callee);
            callback();
        });
        timer.start();
    }

    // ==================== 静态方法 ====================

    /**
     * 创建一个已解决的Promise
     * @param value 解决值
     * @return Promise实例
     */
    public static function resolve(value:* = null):Promise {
        if (value is Promise) {
            return value;
        }

        return new Promise(function (resolve:Function, reject:Function):void {
            resolve(value);
        });
    }

    /**
     * 创建一个已拒绝的Promise
     * @param reason 拒绝原因
     * @return Promise实例
     */
    public static function reject(reason:* = null):Promise {
        return new Promise(function (resolve:Function, reject:Function):void {
            reject(reason);
        });
    }

    /**
     * 等待所有Promise完成
     * @param promises Promise数组
     * @return Promise实例
     */
    public static function all(promises:Array):Promise {
        if (!promises || promises.length === 0) {
            return Promise.resolve([]);
        }

        return new Promise(function (resolve:Function, reject:Function):void {
            var results:Array = new Array(promises.length);
            var completed:int = 0;

            for (var i:int = 0; i < promises.length; i++) {
                (function (index:int):void {
                    var promise:Promise = promises[index] is Promise ?
                            promises[index] : Promise.resolve(promises[index]);

                    promise.then(
                            function (value:*):void {
                                results[index] = value;
                                completed++;
                                if (completed === promises.length) {
                                    resolve(results);
                                }
                            },
                            function (reason:*):void {
                                reject(reason);
                            }
                    );
                })(i);
            }
        });
    }

    /**
     * 返回第一个完成的Promise结果
     * @param promises Promise数组
     * @return Promise实例
     */
    public static function race(promises:Array):Promise {
        return new Promise(function (resolve:Function, reject:Function):void {
            for each (var promise:* in promises) {
                var p:Promise = promise is Promise ? promise : Promise.resolve(promise);
                p.then(resolve, reject);
            }
        });
    }

    /**
     * 等待所有Promise完成，不管成功失败
     * @param promises Promise数组
     * @return Promise实例
     */
    public static function allSettled(promises:Array):Promise {
        if (!promises || promises.length === 0) {
            return Promise.resolve([]);
        }

        return new Promise(function (resolve:Function, reject:Function):void {
            var results:Array = new Array(promises.length);
            var completed:int = 0;

            for (var i:int = 0; i < promises.length; i++) {
                (function (index:int):void {
                    var promise:Promise = promises[index] is Promise ?
                            promises[index] : Promise.resolve(promises[index]);

                    promise.then(
                            function (value:*):void {
                                results[index] = {status: "fulfilled", value: value};
                                completed++;
                                if (completed === promises.length) {
                                    resolve(results);
                                }
                            },
                            function (reason:*):void {
                                results[index] = {status: "rejected", reason: reason};
                                completed++;
                                if (completed === promises.length) {
                                    resolve(results);
                                }
                            }
                    );
                })(i);
            }
        });
    }

    /**
     * 返回第一个成功的Promise，所有都失败才拒绝
     * @param promises Promise数组
     * @return Promise实例
     */
    public static function any(promises:Array):Promise {
        return new Promise(function (resolve:Function, reject:Function):void {
            var errors:Array = [];
            var rejected:int = 0;

            if (!promises || promises.length === 0) {
                reject(new Error("Promise.any called with empty array"));
                return;
            }

            for (var i:int = 0; i < promises.length; i++) {
                (function (index:int):void {
                    var promise:Promise = promises[index] is Promise ?
                            promises[index] : Promise.resolve(promises[index]);

                    promise.then(
                            function (value:*):void {
                                resolve(value);
                            },
                            function (reason:*):void {
                                errors[index] = reason;
                                rejected++;
                                if (rejected === promises.length) {
                                    reject(new Error("All promises were rejected: " + errors.join(", ")));
                                }
                            }
                    );
                })(i);
            }
        });
    }

    /**
     * 创建一个延迟指定时间的Promise
     * @param milliseconds 延迟毫秒数
     * @param value 可选的解决值
     * @return Promise实例
     */
    public static function delay(milliseconds:Number, value:* = null):Promise {
        return new Promise(function (resolve:Function, reject:Function):void {
            var timer:Timer = new Timer(milliseconds, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, function (event:TimerEvent):void {
                timer.removeEventListener(TimerEvent.TIMER_COMPLETE, arguments.callee);
                resolve(value);
            });
            timer.start();
        });
    }

    /**
     * 为Promise添加超时
     * @param promise 目标Promise
     * @param milliseconds 超时毫秒数
     * @param timeoutReason 超时拒绝原因
     * @return Promise实例
     */
    public static function timeout(promise:Promise, milliseconds:Number, timeoutReason:* = null):Promise {
        var timeoutPromise:Promise = new Promise(function (resolve:Function, reject:Function):void {
            var timer:Timer = new Timer(milliseconds, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, function (event:TimerEvent):void {
                timer.removeEventListener(TimerEvent.TIMER_COMPLETE, arguments.callee);
                reject(timeoutReason || new Error("Promise timed out after " + milliseconds + "ms"));
            });
            timer.start();
        });

        return Promise.race([promise, timeoutPromise]);
    }

    /**
     * 转换为字符串表示
     */
    public function toString():String {
        return "[Promise " + _state + "]";
    }
}
}
