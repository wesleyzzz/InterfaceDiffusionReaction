[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 40
  xmax = 40
[]

[MeshModifiers]
  # fuel is block 0, pore is block 1
  [pore]
    type = SubdomainBoundingBox
    bottom_left = '20 0 0'
    block_id = 1
    top_right = '40 1.0 0'
  []
  [interface]
    type = SideSetsBetweenSubdomains
    depends_on = 'pore'
    master_block = '0'
    paired_block = '1'
    new_boundary = 'master_fuel_interface'
  []
[]

[Variables]
  [u]
    order = FIRST
    family = LAGRANGE
    block = '0'
  []
  [v]
    order = FIRST
    family = LAGRANGE
    block = '1'
  []
[]

[AuxVariables]
  [T]
    block = '0 1'
  []
[]

[Kernels]
  [diff_u]
    type = MatDiffusion
    variable = u
    block = '0'
    D_name = D_s
  []
  [diff_v]
    type = MatDiffusion
    variable = v
    block = '1'
    D_name = D_l
  []
  [diff_u_dt]
    type = TimeDerivative
    variable = u
    block = '0'
  []
  [diff_v_dt]
    type = TimeDerivative
    variable = v
    block = '1'
  []
  [source_u]
    type = BodyForce
    variable = u
    block = '0'
  []
  [Liquid_Ln_solute_Soret_Diffusion]
    # Materials Properties
    type = SoretDiffusion
    variable = v
    block = '1'
    diff_name = D_l # Get diffusity from this block
    Q_name = Qheat_liquid # In [Material] Block below, Provide the transport heat
    T = 'T'
  []
  [Solid_Ln_solute_Soret_Diffusion]
    # Materials Properties
    type = SoretDiffusion
    diff_name = D_s
    Q_name = Qheat_liquid
    T = 'T'
    variable = u
    block = '0'
  []
[]

[InterfaceKernels]
  [interface]
    type = InterfaceDiffusion
    variable = u
    neighbor_var = 'v'
    boundary = 'master_fuel_interface'
    D = D_s # Get material D from master
    D_neighbor = D_l # Get material D from neighbor
  []
  [interface_reaction]
    type = InterfaceReaction
    variable = u
    neighbor_var = 'v'
    boundary = 'master_fuel_interface'
    D = D_s
    D_neighbor = D_l
    kf = 1 # Forward reaction rate coefficient
    kb = 2 # Backward reaction rate coefficient
  []
[]

[AuxKernels]
  [Temperature_Interpolation]
    # # use a Parsedfunction to calculate the Temperature, this is Operate on T
    type = FunctionAux
    variable = T
    function = Temp_Interpolation
  []
[]

[BCs]
  [left]
    type = NeumannBC
    variable = u
    boundary = 'left'
  []
  [right]
    type = NeumannBC
    variable = v
    boundary = 'right'
  []
[]

[Materials]
  inactive = 'block0_const_D_s block1_const_D_l'
  [Qheat_liquid]
    type = GenericConstantMaterial
    prop_names = 'Qheat_liquid'
    prop_values = '1.0'
    block = '0 1'
  []
  [Diffusivity_of_Ce_in_Liquid]
    # Arrhenius equation,Use the relationship of Ce in liquid Cs, D=exp(-8.765-0.144/(T*k)) around2.2e-5
    #
    # For testing the code, use exp(600/T),  this value is around 2 with the temp from 853 - 855K.
    type = ParsedMaterial
    function = exp(600/T)
    f_name = D_l
    args = 'T'
    constant_names = 'k'
    constant_expressions = '8.61733e-5'
    block = '1'
  []
  [Diffusivity_of_Ce_in_Solid]
    # Arrhenius equation,Use the relationship of Ce in solid fuel, D=3.61e-8*exp(-1.171/(T*k)) around4.45e-15
    #
    # For testing the code, use exp(1200/T),  this value is around 4 with the temp from 853 - 855K.
    type = ParsedMaterial
    function = exp(1200/T)
    f_name = D_s
    args = 'T'
    constant_names = 'k'
    constant_expressions = '8.61733e-5'
    block = '0'
  []
  [block0_const_D_s]
    type = GenericConstantMaterial
    block = '0'
    prop_names = 'D_s'
    prop_values = '4'
  []
  [block1_const_D_l]
    type = GenericConstantMaterial
    block = '1'
    prop_names = 'D_l'
    prop_values = '2'
  []
[]

[Functions]
  [Temp_Interpolation]
    type = ParsedFunction
    value = 'origin_temp + gradient_x * abs(x - startpoint_x)'
    vars = 'origin_temp startpoint_x gradient_x'
    vals = '855 0.0 -0.05'
  []
  [Sum_all_blocks]
    type = ParsedFunction
    vars = 'Total_dissolve_fuel Total_dissolve_pore'
    value = 'Total_dissolve_fuel+Total_dissolve_pore'
    vals = 'Total_dissolve_fuel Total_dissolve_pore'
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  num_steps = 100
  dt = 1
  solve_type = NEWTON
  end_time = 100
  inactive = 'Adaptivity'
  [Adaptivity]
  []
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
  []
[]

[Outputs]
  exodus = true
[]

[Debug]
  show_var_residual_norms = true
[]

[Postprocessors]
  [Avg_dissolve_fuel]
    type = ElementAverageValue
    variable = 'u'
    block = '0'
  []
  [Avg_dissolve_pore]
    type = ElementAverageValue
    variable = 'v'
    block = '1'
  []
  [Total_dissolve_fuel]
    type = ElementIntegralVariablePostprocessor
    variable = 'u'
    block = '0'
  []
  [Total_dissolve_pore]
    type = ElementIntegralVariablePostprocessor
    variable = 'v'
    block = '1'
  []
  [Total_dissolve]
    type = FunctionValuePostprocessor
    function = Sum_all_blocks
  []
[]
