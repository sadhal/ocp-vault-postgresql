package com.natronq.backend.data;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepo extends JpaRepository<OrderEntity, Long> {
    List<OrderEntity> findByCustomerName(String customerName);
    List<OrderEntity> findByProductName(String productName);
}
