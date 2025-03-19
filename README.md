# Collision_Circle
## 分裂碰撞
### 1.功能介紹
- 生成兩顆隨機速度、方向、顏色的球
- 碰到牆壁時反彈
- 碰到其他球時會反彈，並生成一顆新球

---

### 2.碰撞原理

- 碰撞檢測 (Collision Detection)：

使用**兩球圓心距離與半徑和**來判斷是否發生碰撞

- 碰撞處理 (Collision Response)：

以**二維彈性碰撞**來算出碰撞後的速度：

$$v'_1 = v_1 - \frac{2 m_2}{m_1 + m_2} \frac{(v_1 - v_2) \cdot (x_1 - x_2)}{|x_1 - x_2|^2} (x_1 - x_2)$$

$$v'_2 = v_2 - \frac{2 m_1}{m_1 + m_2} \frac{(v_2 - v_1) \cdot (x_2 - x_1)}{|x_2 - x_1|^2} (x_2 - x_1)$$

- 碰撞後的分裂機制：

為了使新球的運動方式更為合理，讓新球的移動方向設為**垂直於相撞兩球的法向量方向**

---

## 數據結構與優化

在不同版本的中，使用了不同的資料結構來管理球體：

### 1. ArrayList
- 最基本的版本，使用 ArrayList 存儲球。
- **問題**：
  - 由於檢測碰撞是每顆球都與其他球檢測，時間複雜度為 **O(n²)** ，效能太低。
  - ArrayList 的刪除操作效率較低。

### 2. HashMap + LinkedList
- 使用 **HashMap** 來做空間劃分 (**Grid-based Spatial Partitioning**) ，只檢查相鄰格子內的球，大幅降低不必要的碰撞檢測。
- 由 **O(n²) 降至 O(n × k)** （其中 **k** 為平均每個網格內的球數）。
- 使用 **LinkedList** 優化插入刪除操作，避免 ArrayList 的元素搬移問題。

### 3. 多執行緒 + ConcurrentHashMap
- 使用 **多執行緒 (Thread)** 來分批處理球體更新，減少單一執行緒的負擔。
- 使用 **ConcurrentHashMap** 讓多執行緒能安全地讀寫 Grid 資料，避免 race condition。

### 4. ConcurrentLinkedQueue
- 改用 **ConcurrentLinkedQueue**，支援 **Lock-Free** 在多執行緒環境下更穩定。
- 使用 **FIFO (First-In-First-Out)** ，當球數超過限制時，自動刪除最舊的球 **(poll())**。

---
