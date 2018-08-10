package com.natronq.backend;

import com.natronq.backend.data.OrderEntity;
import com.natronq.backend.data.OrderRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;


@RestController
public class OrderAPIController {
    @Autowired
    private OrderRepo repository;

    @org.springframework.beans.factory.annotation.Value("${password}")
    String password;
    
    @org.springframework.beans.factory.annotation.Value("${hemlighet1}")
    String hemlighet1;
    
    @org.springframework.beans.factory.annotation.Value("${hemlighet2}")
	String hemlighet2;

	@RequestMapping("/secret")
	public String secret() {
		return "my secret is" + password;
    }

    @RequestMapping(path="/secrets", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Map<String, String>> secrets() {
        Map<String, String> hemligheter = new HashMap<>();
        hemligheter.put("hemlighet1", hemlighet1);
        hemligheter.put("hemlighet2", hemlighet2);
		return ResponseEntity.ok(hemligheter);
    }

    @RequestMapping(path="/orders", method = RequestMethod.POST)
	public ResponseEntity<?> addOrder(@RequestBody OrderEntity o) {
		// OrderEntity entity = new OrderEntity(o.getCustomerName(), o.getProductName(), new Date());
		o.setOrderDate(new Date());
		return new ResponseEntity<>(repository.save(o), HttpStatus.CREATED);
	}

	@RequestMapping(path="/orders", method = RequestMethod.GET)
	public ResponseEntity<List<OrderEntity>> getAllOrders() {
		List<OrderEntity> orders = repository.findAll();
		// List<Order> os = orders.stream().map(o -> new Order(o.getId(), o.getCustomerName(), o.getProductName(), o.getOrderDate())).collect(Collectors.toList());
		return new ResponseEntity<>(orders, HttpStatus.OK);
	}

	@RequestMapping(path="/orders", method = RequestMethod.DELETE)
	public void deleteAllOrders() {
		repository.deleteAll();
}
}